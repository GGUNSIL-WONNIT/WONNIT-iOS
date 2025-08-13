//
//  BackButtonToolbarModifier.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import Foundation
import SwiftUI

struct BackButtonToolbarModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbarBackground(Color.white)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .contentShape(Rectangle())
                    }
                    .foregroundStyle(Color.grey900)
                    .font(.system(size: 16))
                }
            }
    }
}

extension View {
    func withBackButtonToolbar() -> some View {
        self.modifier(BackButtonToolbarModifier())
    }
}
