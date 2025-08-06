//
//  FocusStateStore.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

enum FormValue: Equatable {
    case string(String)
    case images([UIImage])
    
    var string: String? {
        if case let .string(value) = self { return value }
        return nil
    }
    
    var images: [UIImage]? {
        if case let .images(value) = self { return value }
        return nil
    }
}

@Observable
final class FormStateStore: ObservableObject {
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
    
    func binding<T: LosslessStringConvertible>(for id: String, default defaultValue: T) -> Binding<T> {
        Binding<T>(
            get: {
                if let str = self.values[id]?.string, let value = T(str) {
                    return value
                }
                return defaultValue
            },
            set: { newValue in
                self.values[id] = .string(String(newValue))
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
