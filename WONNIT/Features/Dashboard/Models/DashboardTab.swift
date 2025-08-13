//
//  DashboardTab.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import Foundation

enum DashboardTab: Int, Identifiable, Hashable, Comparable, TabLabelConvertible {
    case myCreatedSpaces
    case myRentedSpaces
    
    var label: String {
        switch self {
        case .myCreatedSpaces:
            return "내가 등록한 공간"
        case .myRentedSpaces:
            return "대여 중인 공간"
        }
    }
    
    var shortWord: String {
        switch self {
        case .myCreatedSpaces:
            return "등록"
        case .myRentedSpaces:
            return "대여"
        }
    }
    
    var isEditable: Bool {
        switch self {
        case .myCreatedSpaces:
            return true
        case .myRentedSpaces:
            return false
        }
    }
    
    var id: Int { rawValue }
    
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

public protocol TabLabelConvertible {
    var label: String { get }
}
