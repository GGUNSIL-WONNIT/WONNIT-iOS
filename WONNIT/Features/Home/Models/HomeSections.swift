//
//  HomeSections.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

enum HomeSections: String, CaseIterable {
    case spaceCategories = "공간 카테고리"
    case recentlyAddedSpaces = "최근 추가된 공간"
    case columns = "칼럼"
    
    var subtitle: String? {
        switch self {
        case .spaceCategories:
            return nil
        case .recentlyAddedSpaces:
            return "나의 활동 목적에 맞는 공간을 선택해보세요."
        case .columns:
            return "유휴공간에 대한 재미있는 소식을 전해드려요."
        }
    }
    
    var subViewHashable: Route? {
        switch self {
        case .recentlyAddedSpaces:
            return .spaceListByRecent
        default:
            return nil
        }
    }
}
