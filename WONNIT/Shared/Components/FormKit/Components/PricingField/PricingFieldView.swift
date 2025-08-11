//
//  PricingFieldView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import UIKit

final class PricingFieldView: UIControl {
    enum ActiveSide { case unit, amount }
    
    struct Style {
        let textSelected: UIColor
        let textNormal: UIColor
        let bgSelected: UIColor
        let bgNormal: UIColor
        let borderSelected: UIColor
        let borderNormal: UIColor
    }
    
    override var canBecomeFirstResponder: Bool { true }
    override var inputView: UIView? {
        switch active {
        case .unit?: return pickerContainer
        case .amount?: return nil
        case nil: return nil
        }
    }
    override var inputAccessoryView: UIView? { toolbar }
    var toolbar: UIToolbar? {
        didSet {
            amountField.inputAccessoryView = toolbar
            if isFirstResponder { reloadInputViews() }
            if amountField.isFirstResponder { amountField.reloadInputViews() }
        }
    }
    
    private let hstack = UIStackView()
    private let unitButton = UIButton(type: .system)
    private let amountField = UITextField()
    private let suffixLabel = UILabel()
    
    private let picker = UIPickerView()
    fileprivate let pickerContainer = UIView(frame: .init(x: 0, y: 0, width: 0, height: 216))
    
    var style: Style? { didSet { updateVisuals() } }
    var unitWidth: CGFloat = 102 { didSet { unitWidthConstraint?.constant = unitWidth } }
    
    var timeUnits: [AmountInfo.TimeUnit] = Array(AmountInfo.TimeUnit.allCases)
    
    var value: AmountInfo = .init(timeUnit: .perDay, amount: 0) {
        didSet { syncUIFromValue(oldValue: oldValue) }
    }
    
    var active: ActiveSide? {
        didSet { syncPickerFromActive(); updateVisuals(); if isFirstResponder { reloadInputViews() } }
    }
    
    private var unitWidthConstraint: NSLayoutConstraint?
    private let amountFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSize = 3
        f.maximumFractionDigits = 0
        f.locale = .current
        return f
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hstack.axis = .horizontal
        hstack.alignment = .fill
        hstack.spacing = 8
        hstack.distribution = .fill
        addSubview(hstack)
        hstack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hstack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hstack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hstack.topAnchor.constraint(equalTo: topAnchor),
            hstack.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
        ])
        
        configureUnitButton(unitButton)
        hstack.addArrangedSubview(unitButton)
        unitWidthConstraint = unitButton.widthAnchor.constraint(equalToConstant: unitWidth)
        unitWidthConstraint?.isActive = true
        
        let amountContainer = UIView()
        amountContainer.translatesAutoresizingMaskIntoConstraints = false
        hstack.addArrangedSubview(amountContainer)
        
        configureAmountField(amountField)
        amountContainer.addSubview(amountField)
        amountField.translatesAutoresizingMaskIntoConstraints = false
        
        configureSuffixLabel(suffixLabel)
        amountContainer.addSubview(suffixLabel)
        suffixLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountField.leadingAnchor.constraint(equalTo: amountContainer.leadingAnchor),
            amountField.topAnchor.constraint(equalTo: amountContainer.topAnchor),
            amountField.bottomAnchor.constraint(equalTo: amountContainer.bottomAnchor),
            amountField.trailingAnchor.constraint(equalTo: suffixLabel.leadingAnchor, constant: -8),
            
            suffixLabel.trailingAnchor.constraint(equalTo: amountContainer.trailingAnchor, constant: -12),
            suffixLabel.centerYAnchor.constraint(equalTo: amountContainer.centerYAnchor),
        ])
        
        picker.dataSource = self
        picker.delegate = self
        pickerContainer.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: pickerContainer.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: pickerContainer.trailingAnchor),
            picker.topAnchor.constraint(equalTo: pickerContainer.topAnchor),
            picker.bottomAnchor.constraint(equalTo: pickerContainer.bottomAnchor),
            picker.heightAnchor.constraint(equalToConstant: 216)
        ])
        
        unitButton.addTarget(self, action: #selector(tapUnit), for: .touchUpInside)
        amountField.addTarget(self, action: #selector(amountEditingChanged), for: .editingChanged)
        addTarget(self, action: #selector(handleTapAnywhere), for: .touchUpInside)
        
        applyBaseDefaults()
        syncUIFromValue(oldValue: nil)
        updateVisuals()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let px = 1.0 / max(1, UIScreen.main.scale)
        [unitButton, amountField].forEach { v in
            v.layer.cornerRadius = 12
            v.layer.cornerCurve = .continuous
            v.layer.borderWidth = px
            v.clipsToBounds = true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let ok = super.becomeFirstResponder()
        if ok, active == nil { active = .unit }
        return ok
    }
    
    override func resignFirstResponder() -> Bool {
        if amountField.isFirstResponder { amountField.resignFirstResponder() }
        let ok = super.resignFirstResponder()
        if ok {
            active = nil
            updateVisuals()
        }
        return ok
    }
    
    private func configureUnitButton(_ b: UIButton) {
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        b.contentHorizontalAlignment = .leading
        
        var cfg = UIButton.Configuration.plain()
        cfg.titleAlignment = .leading
        cfg.contentInsets = .init(top: 14, leading: 16, bottom: 14, trailing: 16)
        b.configuration = cfg
        
        b.setTitle("단위", for: .normal)
    }
    
    private func configureAmountField(_ tf: UITextField) {
        tf.keyboardType = .numberPad
        tf.textAlignment = .left
        tf.font = .systemFont(ofSize: 16, weight: .regular)
        tf.borderStyle = .none
        tf.leftView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 1))
        tf.leftViewMode = .always
        tf.rightViewMode = .never
        tf.placeholder = "금액"
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAmountField))
        tf.addGestureRecognizer(tap)
    }
    
    private func configureSuffixLabel(_ l: UILabel) {
        l.text = "원"
        l.font = .systemFont(ofSize: 16, weight: .regular)
        l.setContentCompressionResistancePriority(.required, for: .horizontal)
        l.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func applyBaseDefaults() {
        unitButton.backgroundColor = .white
        unitButton.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        unitButton.setTitleColor(.label, for: .normal)
        
        amountField.backgroundColor = .white
        amountField.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        amountField.textColor = .label
    }
    
    @objc private func handleTapAnywhere() {
        _ = becomeFirstResponder()
    }
    
    @objc private func tapUnit() {
        if !isFirstResponder { _ = becomeFirstResponder() }
        active = .unit
        if let idx = timeUnits.firstIndex(of: value.timeUnit) {
            picker.selectRow(idx, inComponent: 0, animated: false)
        }
        sendActions(for: .editingDidBegin)
    }
    
    @objc private func tapAmountField() {
        if !isFirstResponder { _ = becomeFirstResponder() }
        active = .amount
        amountField.becomeFirstResponder()
        sendActions(for: .editingDidBegin)
    }
    
    @objc private func amountEditingChanged() {
        let digits = amountField.text?.filter(\.isNumber) ?? ""
        let newAmount = Int(digits) ?? 0
        if newAmount != value.amount {
            value.amount = newAmount
            amountField.text = formattedAmount(newAmount)
            sendActions(for: .valueChanged)
        }
        updateVisuals()
    }
    
    private func syncUIFromValue(oldValue: AmountInfo?) {
        unitButton.setTitle(value.timeUnit.localizedLabel, for: .normal)
        amountField.text = formattedAmount(value.amount)
        if active == .unit, let idx = timeUnits.firstIndex(of: value.timeUnit) {
            picker.selectRow(idx, inComponent: 0, animated: false)
        }
        updateVisuals()
    }
    
    private func syncPickerFromActive() {
        switch active {
        case .unit?:
            if let idx = timeUnits.firstIndex(of: value.timeUnit) {
                picker.selectRow(idx, inComponent: 0, animated: true)
            }
        case .amount?, nil:
            break
        }
    }
    
    private func formattedAmount(_ amount: Int) -> String {
        amountFormatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    private func updateVisuals() {
        guard let style else { return }
        unitButton.backgroundColor = style.bgNormal == .clear ? .white : style.bgNormal
        unitButton.setTitleColor(style.textNormal, for: .normal)
        unitButton.layer.borderColor = style.borderNormal.cgColor
        
        amountField.backgroundColor = style.bgNormal == .clear ? .white : style.bgNormal
        amountField.textColor = style.textNormal
        amountField.layer.borderColor = style.borderNormal.cgColor
        
        if value.amount > 0 {
            amountField.backgroundColor = style.bgSelected
            amountField.textColor = style.textSelected
        }
        unitButton.backgroundColor = style.bgSelected
        unitButton.setTitleColor(style.textSelected, for: .normal)
        
        switch active {
        case .unit?:
            unitButton.layer.borderColor = style.borderSelected.cgColor
        case .amount?:
            amountField.layer.borderColor = style.borderSelected.cgColor
        case nil:
            break
        }
    }
}

extension PricingFieldView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        timeUnits.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        timeUnits[row].localizedLabel
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newUnit = timeUnits[row]
        if newUnit != value.timeUnit {
            value.timeUnit = newUnit
            unitButton.setTitle(newUnit.localizedLabel, for: .normal)
            sendActions(for: .valueChanged)
        }
        updateVisuals()
    }
}
