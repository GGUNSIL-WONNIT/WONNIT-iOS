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
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(Color.grey900)
                            .frame(width: 36, height: 36, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                }
            }
    }
}

extension View {
    func withBackButtonToolbar() -> some View {
        self.modifier(BackButtonToolbarModifier())
    }
}
