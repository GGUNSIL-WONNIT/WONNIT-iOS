//
//  PricingFieldBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct PricingFieldBridge: UIViewRepresentable {
    final class Coordinator: NSObject {
        let parent: PricingFieldBridge
        weak var view: PricingFieldView?
        
        init(_ parent: PricingFieldBridge) { self.parent = parent }
        
        @objc func handlePrev() { parent.onPrev?() }
        @objc func handleNext() { parent.onNext?() }
        @objc func handleDone() {
            if let onDone = parent.onDone { onDone() }
            else { parent.store.blur() }
            let _ = view?.resignFirstResponder()
        }
        
        @objc func valueChanged(_ sender: PricingFieldView) {
            parent.value.wrappedValue = sender.value
        }
        @objc func beganEditing(_ sender: PricingFieldView) { }
    }
    
    let id: String
    let store: FormStateStore
    var value: Binding<AmountInfo>
    
    var style: PickerStyleColorsMapping
    var unitWidth: CGFloat = 102
    var units: [AmountInfo.TimeUnit] = Array(AmountInfo.TimeUnit.allCases)
    
    var onPrev: (() -> Void)? = nil
    var onNext: (() -> Void)? = nil
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> PricingFieldView {
        let v = PricingFieldView()
        
        v.toolbar = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            prev: #selector(Coordinator.handlePrev),
            next: #selector(Coordinator.handleNext),
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
        v.addTarget(context.coordinator, action: #selector(Coordinator.beganEditing(_:)), for: .editingDidBegin)
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
        if shouldFocus, !v.isFirstResponder { _ = v.becomeFirstResponder() }
        if !shouldFocus, v.isFirstResponder   { _ = v.resignFirstResponder() }
    }
}

private extension UIColor {
    convenience init(_ c: UIColor) { self.init(cgColor: c.cgColor) }
}

