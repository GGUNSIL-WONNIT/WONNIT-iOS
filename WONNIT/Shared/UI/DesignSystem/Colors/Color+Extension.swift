//
//  Color+Extension.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

extension Color {
    static let primaryPurple = Color(hex: 0x8245F4)
    static let primaryPurple300 = Color(hex: 0xCFC3FF)
    static let primaryPurple100 = Color(hex: 0xE9E3FF)
    static let grey100 = Color(hex: 0xECEDEF)
    static let grey200 = Color(hex: 0xDBDDE2)
    static let grey300 = Color(hex: 0xC6C8D1)
    static let grey500 = Color(hex: 0x9EA4B4)
    static let grey700 = Color(hex: 0x767984)
    static let grey800 = Color(hex: 0x50525C)
    static let grey900 = Color(hex: 0x24252A)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
