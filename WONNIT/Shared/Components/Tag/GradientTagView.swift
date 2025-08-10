//
//  GradientTagView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/10/25.
//

import SwiftUI

struct GradientTagView: View {
    let label: String
    let backgroundGradient: LinearGradient
    
    init(
        label: String,
        backgroundGradient: LinearGradient =  .init(gradient: Gradient(colors: [Color(hex: 0x6817FF), Color(hex: 0xAA95FF)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    ) {
        self.label = label
        self.backgroundGradient = backgroundGradient
    }
    
    var body: some View {
        Text(label)
            .caption_02(.white)
            .padding(.horizontal, 4)
            .padding(.vertical, 3)
            .background(backgroundGradient)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
    }
}

#Preview {
    GradientTagView(label: "AI 추천")
}
