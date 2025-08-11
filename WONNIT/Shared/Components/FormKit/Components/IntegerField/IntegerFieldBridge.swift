//
//  IntegerFieldBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct IntegerFieldBridge: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        let parent: IntegerFieldBridge
        init(_ parent: IntegerFieldBridge) { self.parent = parent }
        
        @objc func changed(_ tf: UITextField) {
            guard let s = tf.text, !s.isEmpty else { parent.value.wrappedValue = nil; return }
            parent.value.wrappedValue = Int(s)
        }
        
        func textField(_ tf: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowed = parent.allowNegative ? "0123456789-" : "0123456789"
            let current = tf.text ?? ""
            let ns = current as NSString
            let next = ns.replacingCharacters(in: range, with: string)
            if parent.allowNegative, next == "-" { return true } // if negative -> '-' allowed
            return next.allSatisfy { allowed.contains($0) }
        }
        
        func textFieldDidBeginEditing(_ tf: UITextField) {
            if parent.store.focusedID != parent.id {
                DispatchQueue.main.async {
                    self.parent.store.focus(self.parent.id)
                }
            }
        }
        
        func textFieldShouldReturn(_ tf: UITextField) -> Bool {
            return false
        }
        
        @objc func handleDone() { parent.onDone?() }
    }
    
    let id: String
    let store: FormStateStore
    var value: Binding<Int?>
    var placeholder: String? = nil
    var allowNegative: Bool = false
    var readOnly: Bool = false
    
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.delegate = context.coordinator
        tf.keyboardType = .numberPad
        tf.returnKeyType = .next
        tf.inputAccessoryView = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            done: #selector(Coordinator.handleDone)
        )
        tf.borderStyle = .none
        tf.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        if let ph = placeholder {
            tf.attributedPlaceholder = NSAttributedString(string: ph, attributes: [.foregroundColor: UIColor.secondaryLabel])
        }
        tf.isUserInteractionEnabled = !readOnly
        tf.accessibilityIdentifier = id
        return tf
    }
    
    func updateUIView(_ tf: UITextField, context: Context) {
        let s = value.wrappedValue.map(String.init) ?? ""
        if tf.text != s { tf.text = s }
        
        let shouldFocus = (store.focusedID == id)
        if shouldFocus, !tf.isFirstResponder {
            tf.becomeFirstResponder()
        }
        if !shouldFocus, tf.isFirstResponder {
            DispatchQueue.main.async {
                tf.resignFirstResponder()
            }
        }
        tf.isUserInteractionEnabled = !readOnly
    }
}
