//
//  Color+Extension.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

extension Color {
    static let testColor = Color(hex: 0xFF6600)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
