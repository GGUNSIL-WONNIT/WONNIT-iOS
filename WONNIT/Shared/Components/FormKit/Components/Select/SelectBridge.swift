//
//  SelectBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct SelectBridge: UIViewRepresentable {
    final class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
        let parent: SelectBridge
        
        weak var textField: UITextField?
        weak var picker: UIPickerView?
        
        init(_ parent: SelectBridge) { self.parent = parent }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            parent.options.count
        }
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            parent.options[row]
        }
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let value = parent.options[row]
            parent.selection.wrappedValue = value
            textField?.text = value
        }
        
        func textFieldDidBeginEditing(_ tf: UITextField) {
            guard parent.store.focusedID != parent.id else { return }
            parent.store.focus(parent.id)
            
            if let idx = parent.options.firstIndex(of: parent.selection.wrappedValue) {
                picker?.selectRow(idx, inComponent: 0, animated: false)
            }
        }
        
        func textFieldDidEndEditing(_ tf: UITextField) {
            if parent.store.focusedID == parent.id {
                parent.store.blur()
            }
        }
        
        @objc func handleDone() { parent.onDone?() }
    }
    
    let id: String
    let store: FormStateStore
    let options: [String]
    var selection: Binding<String>
    
    var placeholder: String? = nil
    var readOnly: Bool = false
    
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField(frame: .zero)
        tf.delegate = context.coordinator
        tf.borderStyle = .none
        tf.clearButtonMode = .never
        tf.tintColor = .clear
        tf.inputView = {
            let pv = UIPickerView()
            pv.dataSource = context.coordinator
            pv.delegate = context.coordinator
            context.coordinator.picker = pv
            return pv
        }()
        
        tf.inputAccessoryView = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            done: #selector(Coordinator.handleDone)
        )
        
        if let ph = placeholder {
            tf.attributedPlaceholder = NSAttributedString(
                string: ph,
                attributes: [.foregroundColor: UIColor.secondaryLabel]
            )
        }
        
        tf.isUserInteractionEnabled = !readOnly
        tf.accessibilityIdentifier = id
        
        context.coordinator.textField = tf
        return tf
    }
    
    func updateUIView(_ tf: UITextField, context: Context) {
        if selection.wrappedValue.isEmpty {
            if tf.text?.isEmpty == false { tf.text = nil }
        } else if tf.text != selection.wrappedValue {
            tf.text = selection.wrappedValue
        }
        
        let shouldFocus = (store.focusedID == id)
        if shouldFocus, !tf.isFirstResponder { tf.becomeFirstResponder() }
        if !shouldFocus, tf.isFirstResponder { tf.resignFirstResponder() }
        
        context.coordinator.picker?.reloadAllComponents()
    }
}
