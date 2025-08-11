//
//  TimeRangePickerView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import UIKit

final class TimeRangePickerView: UIControl {
    
    enum ActiveSide { case start, end }
    
    struct Style {
        let textSelected: UIColor
        let textNormal: UIColor
        let bgSelected: UIColor
        let bgNormal: UIColor
        let borderSelected: UIColor
        let borderNormal: UIColor
    }
    
    override var canBecomeFirstResponder: Bool { true }
    override var inputView: UIView? { pickerContainer }
    override var inputAccessoryView: UIView? { toolbar }
    
    var toolbar: UIToolbar? {
        didSet { if isFirstResponder { reloadInputViews() } }
    }
    
    private let hstack = UIStackView()
    private let startButton = UIButton(type: .system)
    private let endButton = UIButton(type: .system)
    private let dashLabel = UILabel()
    
    private let picker = UIDatePicker()
    fileprivate let pickerContainer = UIView(frame: .init(x: 0, y: 0, width: 0, height: 216))
    
    var timeRange: TimeRange = .init(startAt: .init(hour: 9, minute: 0), endAt: .init(hour: 18, minute: 0)) {
        didSet {
            updateTitlesAndPicker()
            notifyIfNeededOnProgrammaticChange(oldValue: oldValue)
        }
    }
    
    var active: ActiveSide? {
        didSet {
            syncPickerFromActive()
            updateVisuals()
        }
    }
    
    var style: Style? { didSet { updateVisuals() } }
    
    private let fmt: DateFormatter = {
        let f = DateFormatter()
        f.locale = .current
        f.timeStyle = .short
        f.dateStyle = .none
        return f
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hstack.axis = .horizontal
        hstack.alignment = .fill
        hstack.spacing = 4
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
        
        configureButton(startButton, titleFallback: "시작")
        configureButton(endButton, titleFallback: "종료")
        
        dashLabel.text = "-"
        dashLabel.font = .systemFont(ofSize: 16, weight: .regular)
        dashLabel.textAlignment = .center
        dashLabel.textColor = .label
        dashLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        dashLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        hstack.addArrangedSubview(startButton)
        hstack.addArrangedSubview(dashLabel)
        hstack.addArrangedSubview(endButton)
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalTo: endButton.widthAnchor),
            dashLabel.widthAnchor.constraint(equalToConstant: 12)
        ])
        
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.minuteInterval = 5
        picker.addTarget(self, action: #selector(pickerChanged(_:)), for: .valueChanged)
        
        pickerContainer.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: pickerContainer.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: pickerContainer.trailingAnchor),
            picker.topAnchor.constraint(equalTo: pickerContainer.topAnchor),
            picker.bottomAnchor.constraint(equalTo: pickerContainer.bottomAnchor),
            picker.heightAnchor.constraint(equalToConstant: 216)
        ])
        
        startButton.addTarget(self, action: #selector(tapStart), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(tapEnd), for: .touchUpInside)
        
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        updateTitlesAndPicker()
        updateVisuals()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let px = 1.0 / max(1, UIScreen.main.scale)
        [startButton, endButton].forEach { b in
            b.layer.cornerRadius = 12
            b.layer.cornerCurve = .continuous
            b.layer.borderWidth = px
            b.clipsToBounds = true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let ok = super.becomeFirstResponder()
        if ok && active == nil { active = .start }
        return ok
    }
    
    override func resignFirstResponder() -> Bool {
        let ok = super.resignFirstResponder()
        if ok { active = nil }
        return ok
    }
    
    @objc private func handleTap() { _ = becomeFirstResponder() }
    
    @objc private func tapStart() {
        if !isFirstResponder { _ = becomeFirstResponder() }
        active = .start
        sendActions(for: .editingDidBegin)
    }
    
    @objc private func tapEnd() {
        if !isFirstResponder { _ = becomeFirstResponder() }
        active = .end
        sendActions(for: .editingDidBegin)
    }
    
    @objc private func pickerChanged(_ sender: UIDatePicker) {
        let comps = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        var changed = false
        
        switch active {
        case .start?:
            if timeRange.startAt.hour != comps.hour || timeRange.startAt.minute != comps.minute {
                timeRange.startAt.hour = comps.hour
                timeRange.startAt.minute = comps.minute
                changed = true
            }
            
            if let s = timeRange.startAt.dateValue, let e = timeRange.endAt.dateValue, s > e {
                timeRange.endAt = timeRange.startAt
                changed = true
            }
            
        case .end?:
            if timeRange.endAt.hour != comps.hour || timeRange.endAt.minute != comps.minute {
                timeRange.endAt.hour = comps.hour
                timeRange.endAt.minute = comps.minute
                changed = true
            }
            if let s = timeRange.startAt.dateValue, let e = timeRange.endAt.dateValue, e < s {
                timeRange.startAt = timeRange.endAt
                changed = true
            }
            
        case nil:
            break
        }
        
        if changed {
            updateTitlesAndPicker()
            updateVisuals()
            sendActions(for: .valueChanged)
        } else {
            updateVisuals()
        }
    }
    
    private func configureButton(_ b: UIButton, titleFallback: String) {
        b.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        b.contentHorizontalAlignment = .leading
        
        var cfg = UIButton.Configuration.plain()
        cfg.titleAlignment = .leading
        cfg.contentInsets = .init(top: 14, leading: 16, bottom: 14, trailing: 16)
        b.configuration = cfg
        
        b.setTitle(titleFallback, for: .normal)
        b.backgroundColor = .white
        b.setTitleColor(.label, for: .normal)
        b.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor // fallback ~ grey100
    }
    
    private func text(from comps: DateComponents, fallback: String) -> String {
        guard let d = comps.dateValue else { return fallback }
        return fmt.string(from: d)
    }
    
    private func updateTitlesAndPicker() {
        startButton.setTitle(text(from: timeRange.startAt, fallback: "시작 시간 선택"), for: .normal)
        endButton.setTitle(text(from: timeRange.endAt, fallback: "종료 시간 선택"), for: .normal)
        syncPickerFromActive()
    }
    
    private func syncPickerFromActive() {
        guard let active else { return }
        let date: Date = (active == .start)
        ? (timeRange.startAt.dateValue ?? Date())
        : (timeRange.endAt.dateValue ?? Date())
        picker.setDate(date, animated: true)
    }
    
    private func updateVisuals() {
        guard let style else {
            return
        }
        
        let sChosen = timeRange.startAt.hour != nil
        let eChosen = timeRange.endAt.hour != nil
        
        startButton.backgroundColor = style.bgNormal == .clear ? .white : style.bgNormal
        endButton.backgroundColor   = style.bgNormal == .clear ? .white : style.bgNormal
        startButton.setTitleColor(style.textNormal, for: .normal)
        endButton.setTitleColor(style.textNormal, for: .normal)
        startButton.layer.borderColor = style.borderNormal.cgColor
        endButton.layer.borderColor   = style.borderNormal.cgColor
        
        if sChosen {
            startButton.backgroundColor = style.bgSelected
            startButton.setTitleColor(style.textSelected, for: .normal)
        }
        if eChosen {
            endButton.backgroundColor = style.bgSelected
            endButton.setTitleColor(style.textSelected, for: .normal)
        }
        
        switch active {
        case .start?:
            startButton.layer.borderColor = style.borderSelected.cgColor
        case .end?:
            endButton.layer.borderColor = style.borderSelected.cgColor
        case nil:
            break
        }
    }
    
    private func notifyIfNeededOnProgrammaticChange(oldValue: TimeRange) {
        if oldValue != timeRange {
            updateTitlesAndPicker()
            updateVisuals()
        }
    }
}
