//
//  PhoneNumberFieldBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI
import UIKit

struct PhoneNumberFieldBridge: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        let parent: PhoneNumberFieldBridge
        
        init(_ parent: PhoneNumberFieldBridge) {
            self.parent = parent
        }
        
        @objc func changed(_ tf: UITextField) {
            parent.text.wrappedValue = tf.text ?? ""
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            let digits = updatedText.filter(\.isNumber)
            let formattedText = format(digits: digits)
            
            textField.text = formattedText
            parent.text.wrappedValue = formattedText
            
            let offset = calculateCursorOffset(range: range, replacementString: string, formattedText: formattedText)
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: offset) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            
            return false
        }
        
        private func format(digits: String) -> String {
            var formatted = ""
            let maxLength = 11
            let limitedDigits = String(digits.prefix(maxLength))
            
            if limitedDigits.count > 3 {
                let areaCode = limitedDigits.prefix(3)
                formatted += "\(areaCode)-"
                
                if limitedDigits.count > 7 {
                    let middle = limitedDigits[limitedDigits.index(limitedDigits.startIndex, offsetBy: 3)..<limitedDigits.index(limitedDigits.startIndex, offsetBy: 7)]
                    let end = limitedDigits.suffix(from: limitedDigits.index(limitedDigits.startIndex, offsetBy: 7))
                    formatted += "\(middle)-\(end)"
                } else {
                    let end = limitedDigits.suffix(from: limitedDigits.index(limitedDigits.startIndex, offsetBy: 3))
                    formatted += end
                }
            } else {
                formatted = limitedDigits
            }
            
            return formatted
        }
        
        private func calculateCursorOffset(range: NSRange, replacementString string: String, formattedText: String) -> Int {
            return formattedText.count
        }
        
        func textFieldDidBeginEditing(_ tf: UITextField) {
            if parent.store.focusedID != parent.id {
                DispatchQueue.main.async {
                    self.parent.store.focus(self.parent.id)
                }
            }
        }
        
        @objc func handleDone() { parent.onDone?() }
    }
    
    let id: String
    let store: FormStateStore
    var text: Binding<String>
    
    var placeholder: String? = nil
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.delegate = context.coordinator
        tf.keyboardType = .phonePad
        tf.textContentType = .telephoneNumber
        tf.borderStyle = .none
        tf.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .editingChanged)
        
        if let ph = placeholder {
            tf.attributedPlaceholder = NSAttributedString(string: ph, attributes: [.foregroundColor: UIColor.secondaryLabel])
        }
        
        tf.inputAccessoryView = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            done: #selector(Coordinator.handleDone)
        )
        
        tf.accessibilityIdentifier = id
        return tf
    }
    
    func updateUIView(_ tf: UITextField, context: Context) {
        if tf.text != text.wrappedValue {
            tf.text = text.wrappedValue
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
    }
}
