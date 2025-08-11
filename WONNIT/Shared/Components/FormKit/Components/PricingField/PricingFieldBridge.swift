//
//  PricingFieldBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct PricingFieldBridge: UIViewRepresentable {
    final class Coordinator: NSObject, UITextFieldDelegate {
        let parent: PricingFieldBridge
        weak var view: PricingFieldView?
        
        init(_ parent: PricingFieldBridge) { self.parent = parent }
        
        @objc func handleDone() {
            parent.onDone?()
        }
        
        @objc func valueChanged(_ sender: PricingFieldView) {
            parent.value.wrappedValue = sender.value
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            view?.active = PricingFieldView.ActiveSide.amount
            parent.store.focus(parent.id)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if parent.store.focusedID == parent.id {
                parent.store.blur()
            }
        }
    }
    
    let id: String
    let store: FormStateStore
    var value: Binding<AmountInfo>
    
    var style: PickerStyleColorsMapping
    var unitWidth: CGFloat = 102
    var units: [AmountInfo.TimeUnit] = Array(AmountInfo.TimeUnit.allCases)
    
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> PricingFieldView {
        let v = PricingFieldView()
        
        v.toolbar = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            done: #selector(Coordinator.handleDone)
        )
        
        v.reloadInputViews()
        
        v.style = .init(
            textSelected: UIColor(style.textSelected),
            textNormal: UIColor(style.textNormal),
            bgSelected: UIColor(style.bgSelected),
            bgNormal: UIColor(style.bgNormal),
            borderSelected: UIColor(style.borderSelected),
            borderNormal: UIColor(style.borderNormal)
        )
        
        v.unitWidth = unitWidth
        v.timeUnits = units
        v.value = value.wrappedValue
        
        v.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        v.amountField.delegate = context.coordinator
        v.accessibilityIdentifier = id
        
        context.coordinator.view = v
        return v
    }
    
    func updateUIView(_ v: PricingFieldView, context: Context) {
        if v.value != value.wrappedValue { v.value = value.wrappedValue }
        
        v.style = .init(
            textSelected: UIColor(style.textSelected),
            textNormal: UIColor(style.textNormal),
            bgSelected: UIColor(style.bgSelected),
            bgNormal: UIColor(style.bgNormal),
            borderSelected: UIColor(style.borderSelected),
            borderNormal: UIColor(style.borderNormal)
        )
        v.unitWidth = unitWidth
        v.timeUnits = units
        
        let shouldFocus = (store.focusedID == id)
        if shouldFocus, !v.isEditing { _ = v.becomeFirstResponder() }
        if !shouldFocus, v.isEditing { _ = v.resignFirstResponder() }
    }
}

private extension UIColor {
    convenience init(_ c: UIColor) { self.init(cgColor: c.cgColor) }
}

