//
//  EditSpaceFormStep.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import Foundation

enum EditSpaceFormStep: CaseIterable, Identifiable {
    case pictures
    case details
    case operation
    case miscellaneous
    case roomScan
    
    var id: String { "\(self)" }
    
    var title: String {
        switch self {
        case .pictures:
            return "공간 사진"
        case .details:
            return "공간 상세정보"
        case .operation:
            return "시간 및 금액정보"
        case .miscellaneous:
            return "기타 정보"
        case .roomScan:
            return "3D 스캔"
        }
    }
}
