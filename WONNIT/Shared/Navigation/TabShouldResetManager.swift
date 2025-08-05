//
//  TabShouldResetManager.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import Foundation

@Observable
final class TabShouldResetManager {
    private(set) var resetTriggers: [TabManager.TabBarItems: UUID] = {
        var dict = [TabManager.TabBarItems: UUID]()
        for tab in TabManager.TabBarItems.allCases {
            dict[tab] = UUID()
        }
        return dict
    }()
    
    func triggerReset(for tab: TabManager.TabBarItems) {
        resetTriggers[tab] = UUID()
    }
}
