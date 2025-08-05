//
//  ColoredTagView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import SwiftUI

struct ColoredTagView: View {
    let label: String
    let size: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color
    let paddings: EdgeInsets
    
    init(label: String, size: CGFloat = 12, foregroundColor: Color = .primaryPurple, backgroundColor: Color = .primaryPurple100, paddings: EdgeInsets = .init(top: 3, leading: 4, bottom: 3, trailing: 4)) {
        self.label = label
        self.size = size
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.paddings = paddings
    }
    
    var body: some View {
        Text(label)
            .font(.custom("Pretendard-Medium", size: size))
            .kerning(-0.06)
            .lineSpacing(1.2)
            .foregroundStyle(foregroundColor)
            .padding(paddings)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .accessibilityLabel("공간 카테고리: \(label)")
    }
}

#Preview {
    ColoredTagView(label: "스터디룸")
}
