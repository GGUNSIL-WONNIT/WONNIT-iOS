//
//  ReturnSpaceStep.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

enum ReturnSpaceStep: CaseIterable, Identifiable {
    case before
    case after
    case result
    
    var id: String { "\(self)" }
    
    var sectionTitle: String {
        switch self {
        case .before:
            return"사용 전 공간 사진을\n등록해주세요"
        case .after:
            return"사용 후 공간 사진을\n등록해주세요"
        case .result:
            return"AI 분석 결과"
        }
    }
    
    var isOptional: Bool {
        return false
    }
    
    var next: ReturnSpaceStep? {
        guard let idx = Self.allCases.firstIndex(of: self),
              idx + 1 < Self.allCases.count else { return nil }
        return Self.allCases[idx + 1]
    }
    
    var previous: ReturnSpaceStep? {
        guard let idx = Self.allCases.firstIndex(of: self),
              idx > 0 else { return nil }
        return Self.allCases[idx - 1]
    }
}
