//
//  TimeRangePickerBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import SwiftUI
import UIKit

struct TimeRangePickerBridge: UIViewRepresentable {
    final class Coordinator: NSObject {
        let parent: TimeRangePickerBridge
        weak var view: TimeRangePickerView?
        
        init(_ parent: TimeRangePickerBridge) { self.parent = parent }
        
        @objc func handleDone() {
            parent.onDone?()
        }
        
        @objc func valueChanged(_ sender: TimeRangePickerView) {
            parent.value.wrappedValue = sender.timeRange
        }
        
        @objc func beganEditing(_ sender: TimeRangePickerView) {
            if parent.store.focusedID != parent.id {
                DispatchQueue.main.async {
                    self.parent.store.focus(self.parent.id)
                }
            }
        }
    }
    
    let id: String
    let store: FormStateStore
    var value: Binding<TimeRange>
    
    var style: PickerStyleColorsMapping
    
    var onDone: (() -> Void)? = nil
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> TimeRangePickerView {
        let v = TimeRangePickerView()
        
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
        v.timeRange = value.wrappedValue
        
        v.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        v.addTarget(context.coordinator, action: #selector(Coordinator.beganEditing(_:)), for: .editingDidBegin)
        v.accessibilityIdentifier = id
        
        context.coordinator.view = v
        return v
    }
    
    func updateUIView(_ v: TimeRangePickerView, context: Context) {
        if v.timeRange != value.wrappedValue {
            v.timeRange = value.wrappedValue
        }
        
        v.style = .init(
            textSelected: UIColor(style.textSelected),
            textNormal: UIColor(style.textNormal),
            bgSelected: UIColor(style.bgSelected),
            bgNormal: UIColor(style.bgNormal),
            borderSelected: UIColor(style.borderSelected),
            borderNormal: UIColor(style.borderNormal)
        )
        
        let shouldFocus = (store.focusedID == id)
        if shouldFocus, !v.isEditing {
            _ = v.becomeFirstResponder()
        }
        if !shouldFocus, v.isEditing {
            DispatchQueue.main.async {
                _ = v.resignFirstResponder()
            }
        }
    }
}

private extension UIColor {
    convenience init(_ c: UIColor) { self.init(cgColor: c.cgColor) }
}
