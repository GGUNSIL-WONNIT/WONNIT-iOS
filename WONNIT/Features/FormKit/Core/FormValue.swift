//
//  FormValue.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

enum FormValue: Equatable {
    case string(String)
    case double(Double)
    case int(Int)
    case bool(Bool)
    case codable(Data)
    case images([UIImage])
    case none
    
    var string: String? {
        switch self {
        case let .string(value):
            return value
        case let .int(value):
            return String(value)
        case let .double(value):
            return String(value)
        default:
            return nil
        }
    }
    
    var double: Double? {
        switch self {
        case let .double(value):
            return value
        case let .string(value):
            return Double(value)
        case let .int(value):
            return Double(value)
        default:
            return nil
        }
    }
    
    var int: Int? {
        switch self {
        case let .int(value):
            return value
        case let .string(value):
            return Int(value)
        case let .double(value):
            return Int(value)
        default:
            return nil
        }
    }
    
    var bool: Bool? {
        if case let .bool(value) = self { return value }
        return nil
    }
    
    var images: [UIImage]? {
        if case let .images(value) = self { return value }
        return nil
    }
    
    var codableData: Data? {
        if case let .codable(data) = self { return data }
        return nil
    }
    
    var amountInfo: AmountInfo? {
        decoded(as: AmountInfo.self)
    }
    
    var isEmpty: Bool {
        switch self {
        case .string(let str): return str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .double(let value): return value == 0
        case .int(let value): return value == 0
        case .bool(let value): return !value
        case .images(let imgs): return imgs.isEmpty
        case .codable(let data): return data.isEmpty
        case .none: return true
        }
    }
    
    func decoded<T: Decodable>(as type: T.Type) -> T? {
        guard case let .codable(data) = self else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
