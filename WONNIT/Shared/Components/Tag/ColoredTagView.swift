//
//  ColoredTagView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import SwiftUI

struct ColoredTagView: View {
    let label: String
    let size: CGFloat = 12
    let foregroundColor: Color = .primaryPurple
    let backgroundColor: Color = .primaryPurple100
    let paddings: EdgeInsets = .init(top: 3, leading: 4, bottom: 3, trailing: 4)
    
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
