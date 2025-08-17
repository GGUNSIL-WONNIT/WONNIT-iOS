//
//  Keys.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/17/25.
//

import Foundation

enum Secrets {
    static var kakao: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_KEY") as? String else {
            fatalError("KAKAO_REST_KEY not found in Info.plist")
        }
        return key
    }
}
