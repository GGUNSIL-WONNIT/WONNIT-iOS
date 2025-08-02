//
//  TabBarItems.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

enum TabBarItems: Int, CaseIterable {
    case home = 0
    case explore
    case dashboard
    
    var label: String {
         switch self {
         case .home:
             return "홈"
         case .explore:
             return "탐색"
         case .dashboard:
             return "마이"
         }
     }
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .explore:
            return "map"
        case .dashboard:
            return "person"
        }
    }
    
    var iconNameSelected: String {
        return iconName + ".fill"
    }
}
