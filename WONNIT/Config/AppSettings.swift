//
//  AppSettings.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import SwiftUI

@Observable
final class AppSettings {
//    @AppStorage("selectedTestUserID")
//    var selectedTestUserID: String = TestUser.user1.rawValue
    var selectedTestUserID: String {
        get {
            access(keyPath: \.selectedTestUserID)
            return UserDefaults.standard.string(forKey: "selectedTestUserID") ?? TestUser.user1.rawValue
        }
        set {
            withMutation(keyPath: \.selectedTestUserID) {
                UserDefaults.standard.set(newValue, forKey: "selectedTestUserID")
            }
        }
    }
}
