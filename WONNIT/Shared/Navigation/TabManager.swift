//
//  TabManager.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation
import SwiftUI

@Observable
class TabManager {
    enum TabBarItems: CaseIterable, Hashable {
        case home
        case explore
        case dashboard
        
        var label: String {
            switch self {
            case .home: return "홈"
            case .explore: return "탐색"
            case .dashboard: return "마이"
            }
        }

        var iconName: String {
            switch self {
            case .home: return "house"
            case .explore: return "map"
            case .dashboard: return "person"
            }
        }

        var iconNameSelected: String {
            iconName + ".fill"
        }
    }

    var selectedTab: TabBarItems = .home
}
