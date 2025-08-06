//
//  FocusStateStore.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

@Observable
final class FormStateStore {
    var values: [String: FormValue] = [:]
    var focusedID: String?
    
    func binding(for id: String, default defaultValue: String = "") -> Binding<String> {
        Binding<String>(
            get: {
                (self.values[id]?.string) ?? defaultValue
            },
            set: { newValue in
                self.values[id] = .string(newValue)
            }
        )
    }
    
    func binding(for id: String, default defaultValue: Double) -> Binding<Double> {
        Binding<Double>(
            get: {
                if case let .double(value) = self.values[id] {
                    return value
                }
                if case let .string(str) = self.values[id], let val = Double(str) {
                    return val
                }
                return defaultValue
            },
            set: { newValue in
                self.values[id] = .double(newValue)
            }
        )
    }
    
    func binding<T: Codable & Hashable>(for id: String, default defaultValue: T) -> Binding<T> {
        Binding<T>(
            get: {
                if let value = self.values[id], case let .codable(data) = value {
                    return (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
                }
                return defaultValue
            },
            set: { newValue in
                if let encoded = try? JSONEncoder().encode(newValue) {
                    self.values[id] = .codable(encoded)
                }
            }
        )
    }
    
    func imageBinding(for id: String) -> Binding<[UIImage]> {
        Binding<[UIImage]>(
            get: {
                if case let .images(images) = self.values[id] {
                    return images
                }
                return []
            },
            set: { newImages in
                self.values[id] = .images(newImages)
            }
        )
    }
}
