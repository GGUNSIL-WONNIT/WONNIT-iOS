//
//  FocusStateStore.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

@Observable
final class FormStateStore: ObservableObject {
    var values: [String: String] = [:]
    var focusedID: String?
    
    func binding(for id: String) -> Binding<String> {
        Binding<String>(
            get: { self.values[id] ?? "" },
            set: { self.values[id] = $0 }
        )
    }
    
    func binding(for id: String) -> Binding<Double> {
        Binding<Double>(
            get: { Double(self.values[id] ?? "") ?? 0.0 },
            set: { self.values[id] = String($0) }
        )
    }
    
    func binding(for id: String) -> Binding<Int> {
        Binding<Int>(
            get: { Int(self.values[id] ?? "") ?? 0 },
            set: { self.values[id] = String($0) }
        )
    }
    
    func binding(for id: String) -> Binding<Bool> {
        Binding<Bool>(
            get: { Bool(self.values[id] ?? "") ?? false },
            set: { self.values[id] = String($0) }
        )
    }
    
    func isStepValid(_ step: CreateSpaceFormStep) -> Bool {
        for component in step.components {
            let id = component.id
            let value = values[id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if value.isEmpty {
                return false
            }
        }
        return true
    }
}
