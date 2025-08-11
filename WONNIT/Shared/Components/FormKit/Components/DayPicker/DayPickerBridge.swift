//
//  DayPickerBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct DayPickerBridge: UIViewRepresentable {
    final class Coordinator: NSObject {
        let parent: DayPickerBridge
        weak var view: DayPickerView?
        
        init(_ parent: DayPickerBridge) { self.parent = parent }
        
        @objc func valueChanged(_ sender: DayPickerView) {
            parent.selection.wrappedValue = sender.selectedDays
        }
        
        @objc func beganEditing(_ sender: DayPickerView) {
            if parent.store.focusedID != parent.id {
                parent.store.focus(parent.id)
            }
        }
        
        @objc func handleDone() { parent.onDone?() }
    }
    
    let id: String
    let store: FormStateStore
    var selection: Binding<Set<DayOfWeek>>
    
    var style: PickerStyleColorsMapping
    
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> DayPickerView {
        let v = DayPickerView()
        
        v.toolbar = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            done: #selector(Coordinator.handleDone)
        )
        
        v.selectedDays = selection.wrappedValue
        v.applyStyle(style)
        
        v.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        v.addTarget(context.coordinator, action: #selector(Coordinator.beganEditing(_:)), for: .editingDidBegin)
        v.accessibilityIdentifier = id
        
        context.coordinator.view = v
        return v
    }
    
    func updateUIView(_ v: DayPickerView, context: Context) {
        if v.selectedDays != selection.wrappedValue {
            v.selectedDays = selection.wrappedValue
        }
        
        v.applyStyle(style)
        
        if store.focusedID == id, !v.isFirstResponder { _ = v.becomeFirstResponder() }
        if store.focusedID != id, v.isFirstResponder { _ = v.resignFirstResponder() }
    }
}
