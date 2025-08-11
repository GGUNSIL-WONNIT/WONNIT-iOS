//
//  TextFieldBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct TextFieldBridge: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        let parent: TextFieldBridge
        init(_ parent: TextFieldBridge) { self.parent = parent }
        
        func textFieldDidBeginEditing(_ tf: UITextField) {
            if parent.store.focusedID != parent.id {
                parent.store.focus(parent.id)
            }
        }
        
        @objc func changed(_ tf: UITextField) {
            parent.text.wrappedValue = tf.text ?? ""
        }
        
        func textFieldShouldReturn(_ tf: UITextField) -> Bool {
            return false
        }
        
        @objc func handleDone() { parent.onDone?() }
    }
    
    let id: String
    let store: FormStateStore
    var text: Binding<String>
    
    var placeholder: String? = nil
    var isSecure: Bool = false
    var keyboard: UIKeyboardType = .default
    var returnKey: UIReturnKeyType = .next
    var submitLabel: SubmitLabel = .next
    var readOnly: Bool = false
    var characterLimit: Int? = nil
    
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.delegate = context.coordinator
        tf.text = text.wrappedValue
        tf.isSecureTextEntry = isSecure
        tf.keyboardType = keyboard
        tf.returnKeyType = returnKey
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing
        tf.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        if let ph = placeholder {
            tf.attributedPlaceholder = NSAttributedString(string: ph, attributes: [.foregroundColor: UIColor.secondaryLabel])
        }
        tf.inputAccessoryView = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            done: #selector(Coordinator.handleDone)
        )
        tf.isUserInteractionEnabled = !readOnly
        tf.accessibilityIdentifier = id
        return tf
    }
    
    func updateUIView(_ tf: UITextField, context: Context) {
        if tf.text != text.wrappedValue { tf.text = text.wrappedValue }
        if let limit = characterLimit, let t = tf.text, t.count > limit {
            let clipped = String(t.prefix(limit))
            tf.text = clipped
            text.wrappedValue = clipped
        }
        
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
        tf.keyboardType = keyboard
        tf.returnKeyType = returnKey
    }
}
