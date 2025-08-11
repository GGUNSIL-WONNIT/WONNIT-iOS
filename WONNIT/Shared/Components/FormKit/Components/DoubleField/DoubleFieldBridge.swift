//
//  DoubleFieldBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct DoubleFieldBridge: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        let parent: DoubleFieldBridge
        let formatter: NumberFormatter
        
        init(_ parent: DoubleFieldBridge) {
            self.parent = parent
            self.formatter = NumberFormatter()
            formatter.locale = parent.locale
            formatter.numberStyle = .decimal
            formatter.usesGroupingSeparator = false
            formatter.maximumFractionDigits = parent.maxFractionDigits
        }
        
        @objc func changed(_ tf: UITextField) {
            guard let s = tf.text, !s.isEmpty else {
                parent.value.wrappedValue = nil; return
            }
            // TODO: - Accept partial input like -, . -
            if let n = formatter.number(from: s)?.doubleValue {
                parent.value.wrappedValue = n
            } else {
            }
        }
        
        func textFieldDidBeginEditing(_ tf: UITextField) {
            if parent.store.focusedID != parent.id { parent.store.focus(parent.id) }
        }
        func textFieldDidEndEditing(_ tf: UITextField) {
            if parent.store.focusedID == parent.id { parent.store.blur() }
            if let v = parent.value.wrappedValue {
                tf.text = formatter.string(from: NSNumber(value: v))
            }
        }
        
        func textField(_ tf: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard parent.allowNegative || string != "-" else { return false }
            let current = tf.text ?? ""
            let ns = current as NSString
            let next = ns.replacingCharacters(in: range, with: string)
            
            if parent.maxFractionDigits >= 0, let dot = next.firstIndex(of: ".") {
                let frac = next[next.index(after: dot)...]
                if frac.count > parent.maxFractionDigits { return false }
            }
            
            let allowed = parent.allowNegative ? "0123456789.-" : "0123456789."
            return next.allSatisfy { allowed.contains($0) }
        }
        
        func textFieldShouldReturn(_ tf: UITextField) -> Bool {
            parent.onReturn?() ?? { tf.resignFirstResponder() }()
            return false
        }
        
        @objc func handlePrev() { parent.onPrev?() }
        @objc func handleNext() { parent.onNext?() }
        @objc func handleDone() { parent.onDone?() ?? { parent.store.blur() }() }
    }
    
    let id: String
    let store: FormStateStore
    var value: Binding<Double?>
    
    var placeholder: String? = nil
    var maxFractionDigits: Int = 2
    var allowNegative: Bool = false
    var locale: Locale = .current
    var readOnly: Bool = false
    
    var onReturn: (() -> Void)? = nil
    var onPrev: (() -> Void)? = nil
    var onNext: (() -> Void)? = nil
    var onDone:  (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.delegate = context.coordinator
        tf.keyboardType = .decimalPad
        tf.returnKeyType = .done
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.borderStyle = .none
        tf.clearButtonMode = .never
        tf.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        if let ph = placeholder {
            tf.attributedPlaceholder = NSAttributedString(string: ph, attributes: [.foregroundColor: UIColor.secondaryLabel])
        }
        tf.inputAccessoryView = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            prev: #selector(Coordinator.handlePrev),
            next: #selector(Coordinator.handleNext),
            done: #selector(Coordinator.handleDone)
        )
        tf.isUserInteractionEnabled = !readOnly
        tf.accessibilityIdentifier = id
        return tf
    }
    
    func updateUIView(_ tf: UITextField, context: Context) {
        if let v = value.wrappedValue {
            let s = context.coordinator.formatter.string(from: NSNumber(value: v)) ?? ""
            if tf.text != s { tf.text = s }
        } else if (tf.text?.isEmpty == false) {
            tf.text = ""
        }
        
        let shouldFocus = (store.focusedID == id)
        if shouldFocus, !tf.isFirstResponder { tf.becomeFirstResponder() }
        if !shouldFocus, tf.isFirstResponder { tf.resignFirstResponder() }
        tf.isUserInteractionEnabled = !readOnly
    }
}
