//
//  DeterministicTextField.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/10/25.
//

import Foundation
import SwiftUI

struct DeterministicTextField: UIViewRepresentable {
    let id: String
    var placeholder: String?
    @Binding var text: String
    
    var isEnabled: Bool = true
    var keyboardType: UIKeyboardType = .default
    var returnKeyType: UIReturnKeyType = .default
    var font: UIFont = .systemFont(ofSize: 15, weight: .regular)
    var contentInsets: UIEdgeInsets = .init(top: 6, left: 8, bottom: 6, right: 8)
    
    @Environment(FormStateStore.self) private var store
    
    func makeUIView(context: Context) -> Field {
        let tf = Field()
        tf.delegate = context.coordinator
        tf.placeholder = placeholder
        tf.keyboardType = keyboardType
        tf.returnKeyType = returnKeyType
        tf.font = font
        tf.contentInsets = contentInsets
        tf.borderStyle = .none
        tf.clearButtonMode = .never
        tf.setContentCompressionResistancePriority(.required, for: .vertical)
        tf.setContentHuggingPriority(.required, for: .vertical)
        tf.addTarget(context.coordinator, action: #selector(Coordinator.editingChanged(_:)), for: .editingChanged)
        tf.accessibilityIdentifier = id
        return tf
    }
    
    func updateUIView(_ tf: Field, context: Context) {
        tf.isEnabled = isEnabled
        if tf.text != text { tf.text = text }
        
        let shouldBeFocused = (store.focusedID == id)
        if shouldBeFocused && !tf.isFirstResponder {
            DispatchQueue.main.async { tf.becomeFirstResponder() }
        } else if !shouldBeFocused && tf.isFirstResponder {
            DispatchQueue.main.async { tf.resignFirstResponder() }
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DeterministicTextField
        init(_ parent: DeterministicTextField) { self.parent = parent }
        
        @objc func editingChanged(_ sender: UITextField) {
            parent.text = sender.text ?? ""
        }
        
        func textFieldShouldReturn(_ tf: UITextField) -> Bool {
            parent.store.next()
            return true
        }
    }
}

final class Field: UITextField {
    var contentInsets: UIEdgeInsets = .zero { didSet { invalidateIntrinsicContentSize() } }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: contentInsets) }
    override func editingRect(forBounds bounds: CGRect) -> CGRect { bounds.inset(by: contentInsets) }
    
    override var intrinsicContentSize: CGSize {
        let h = (font?.lineHeight ?? 17) + contentInsets.top + contentInsets.bottom
        return CGSize(width: UIView.noIntrinsicMetric, height: ceil(h))
    }
}
