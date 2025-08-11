//
//  DayPickerView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

public struct PickerStyleColorsMapping {
    let textSelected: UIColor
    let textNormal: UIColor
    let bgSelected: UIColor
    let bgNormal: UIColor
    let borderSelected: UIColor
    let borderNormal: UIColor
    
    public init(
        textSelected: UIColor,
        textNormal: UIColor,
        bgSelected: UIColor,
        bgNormal: UIColor,
        borderSelected: UIColor,
        borderNormal: UIColor
    ) {
        self.textSelected = textSelected
        self.textNormal = textNormal
        self.bgSelected = bgSelected
        self.bgNormal = bgNormal
        self.borderSelected = borderSelected
        self.borderNormal = borderNormal
    }
}

final class DayPickerView: UIControl {
    override var canBecomeFirstResponder: Bool { true }
    
    override var inputView: UIView? {
        if _inputView == nil {
            let v = UIView(frame: .init(x: 0, y: 0, width: 0, height: 1))
            v.backgroundColor = .clear
            _inputView = v
        }
        return _inputView
    }
    private var _inputView: UIView?
    
    override var inputAccessoryView: UIView? { toolbar }
    weak var toolbar: UIToolbar?
    
    let stack = UIStackView()
    var buttons: [UIButton] = []
    
    var order: [DayOfWeek] = DayOfWeek.allCases
    var selectedDays: Set<DayOfWeek> = [] {
        didSet { updateSelectionUI() }
    }
    
    var style: PickerStyleColorsMapping!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .equalSpacing
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])
        
        order.forEach { day in
            let b = UIButton(type: .system)
            b.setTitle(day.localizedLabel, for: .normal)
            b.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            
            var cfg = UIButton.Configuration.plain()
            cfg.contentInsets = .zero
            b.configuration = cfg
            b.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                b.widthAnchor.constraint(equalToConstant: 40),
                b.heightAnchor.constraint(equalTo: b.widthAnchor)
            ])
            b.layer.borderWidth = 1
            b.layer.masksToBounds = true
            b.layer.cornerRadius = 20
            
            b.addTarget(self, action: #selector(toggleDay(_:)), for: .touchUpInside)
            b.accessibilityIdentifier = "day.\(day.rawValue)"
            buttons.append(b)
            stack.addArrangedSubview(b)
        }
        
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc private func handleTap() {
        _ = becomeFirstResponder()
    }
    
    @objc private func toggleDay(_ sender: UIButton) {
        guard let idx = buttons.firstIndex(of: sender) else { return }
        let day = order[idx]
        if selectedDays.contains(day) { selectedDays.remove(day) } else { selectedDays.insert(day) }
        sendActions(for: .valueChanged)
    }
    
    func applyStyle(_ style: PickerStyleColorsMapping) {
        self.style = style
        updateSelectionUI()
    }
    
    private func updateSelectionUI() {
        guard let style else { return }
        for (idx, b) in buttons.enumerated() {
            let day = order[idx]
            let isOn = selectedDays.contains(day)
            b.backgroundColor = isOn ? style.bgSelected : style.bgNormal
            b.setTitleColor(isOn ? style.textSelected : style.textNormal, for: .normal)
            b.layer.borderColor = (isOn ? style.borderSelected : style.borderNormal).cgColor
        }
    }
}
