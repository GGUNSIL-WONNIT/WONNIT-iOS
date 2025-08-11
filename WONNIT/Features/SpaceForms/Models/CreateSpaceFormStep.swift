//
//  CreateSpaceFormStep.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

enum CreateSpaceFormStep: CaseIterable, Identifiable {
    case addressAndName
    case pictures
    case categoryAndTags
    case operation
    case scanner
    case miscellaneous
    
    var id: String { "\(self)" }
    
    var sectionTitle: String {
        switch self {
        case .addressAndName:
            return "공간 주소와 이름 정보를\n입력해주세요"
        case .pictures:
            return "공간 사진과 기본정보를\n등록해주세요"
        case .categoryAndTags:
            return "공간 카테고리와 구비물품을\n확인해주세요"
        case .operation:
            return "공간 대여 정보 및\n금액을 입력해주세요"
        case .scanner:
            return "3D 스캔 정보를\n등록해주세요(선택)"
        case .miscellaneous:
            return "기타 정보를 등록해주세요"
        }
    }
    
    var isOptional: Bool {
        switch self {
        case .scanner:
            return true
        default:
            return false
        }
    }
    
    var next: CreateSpaceFormStep? {
        guard let idx = Self.allCases.firstIndex(of: self),
              idx + 1 < Self.allCases.count else { return nil }
        return Self.allCases[idx + 1]
    }
    
    var previous: CreateSpaceFormStep? {
        guard let idx = Self.allCases.firstIndex(of: self),
              idx > 0 else { return nil }
        return Self.allCases[idx - 1]
    }
}
