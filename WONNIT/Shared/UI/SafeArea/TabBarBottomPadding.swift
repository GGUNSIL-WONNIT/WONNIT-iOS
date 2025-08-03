//
//  TabBarBottomPadding.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation
import SwiftUI

struct SafeAreaBottomPadding: ViewModifier {
    @Environment(\.safeAreaInsets) private var insets
    var padding: CGFloat = 40
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, insets.bottom + padding)
    }
}

extension View {
    func paddedForTabBar() -> some View {
        self.modifier(SafeAreaBottomPadding())
    }
}
