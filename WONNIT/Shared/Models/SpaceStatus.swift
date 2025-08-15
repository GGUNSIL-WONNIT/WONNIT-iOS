//
//  SpaceStatus.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import Foundation
import SwiftUI

enum SpaceStatus: String, Codable, CaseIterable {
    case available = "AVAILABLE"
    case occupied = "OCCUPIED"
    case returnRequest = "RETURN_REQUEST"
    case returnRejected = "RETURN_REJECTED"
    
    var label: String {
        switch self {
        case .available:
            return "대여 가능"
        case .occupied:
            return "대여 중"
        case .returnRequest:
            return "반납 요청됨"
        case .returnRejected:
            return "반납 반려"
        }
    }
    
    @ViewBuilder
    var statusIndicator: some View {
        switch self {
        case .available:
            Text("대여 중")
                .body_05(.primaryPurple)
                .frame(maxWidth: .infinity, alignment: .trailing)
        case .returnRejected:
            Text("반납 반려")
                .body_02(.grey800)
                .frame(maxWidth: .infinity, alignment: .leading)
        default:
            EmptyView()
        }
    }
}
