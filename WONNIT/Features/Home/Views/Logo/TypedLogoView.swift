//
//  TypedLogoView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import SwiftUI

struct TypedLogoView: View {

    var body: some View {
        HStack {
            Image("typedLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 33)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
