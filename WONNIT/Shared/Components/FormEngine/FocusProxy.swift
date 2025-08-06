//
//  FocusProxy.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation
import SwiftUI

struct FocusProxy: View {
    let id: String
    @FocusState var focused: String?
    
    var body: some View {
        TextField("", text: .constant(""))
            .focused($focused, equals: id)
            .opacity(0)
            .frame(width: 0, height: 0)
            .disabled(true)
    }
}

extension View {
    func focusProxy(for id: String, binding: FocusState<String?>.Binding) -> some View {
        self.background(
            TextField("", text: .constant(""))
                .focused(binding, equals: id)
                .opacity(0)
                .frame(width: 0, height: 0)
                .allowsHitTesting(false)
//                .disabled(true)
        )
    }
}
