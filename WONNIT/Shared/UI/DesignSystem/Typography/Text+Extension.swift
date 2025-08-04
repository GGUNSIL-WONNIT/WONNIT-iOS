//
//  Font+Extension.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

extension Text {
    func title_01(_ color: Color? = nil) -> some View {
        styled("Pretendard-SemiBold", 24, -0.12, 9.6, color)
    }
    
    func title_01_text() -> Text {
        self.font(.custom("Pretendard-SemiBold", size: 24))
            .kerning(-0.12)
    }
    
    func title_02(_ color: Color? = nil) -> some View {
        styled("Pretendard-Medium", 24, -0.12, 9.6, color)
    }
    
    func head_01(_ color: Color? = nil) -> some View {
        styled("Pretendard-SemiBold", 20, -0.10, 8.0, color)
    }
    
    func head_02(_ color: Color? = nil) -> some View {
        styled("Pretendard-Regular", 20, -0.10, 8.0, color)
    }
    
    func body_01(_ color: Color? = nil) -> some View {
        styled("Pretendard-SemiBold", 18, -0.09, 7.2, color)
    }
    
    func body_02(_ color: Color? = nil) -> some View {
        styled("Pretendard-Medium", 18, -0.09, 7.2, color)
    }
    
    func body_03(_ color: Color? = nil) -> some View {
        styled("Pretendard-SemiBold", 16, -0.08, 8.0, color)
    }
    
    func body_04(_ color: Color? = nil) -> some View {
        styled("Pretendard-Regular", 16, -0.08, 8.0, color)
    }
    
    func body_05(_ color: Color? = nil) -> some View {
        styled("Pretendard-Medium", 14, -0.07, 7.0, color)
    }
    
    func body_06(_ color: Color? = nil) -> some View {
        styled("Pretendard-Regular", 14, -0.07, 7.0, color)
    }
    
    func caption_01(_ color: Color? = nil) -> some View {
        styled("Pretendard-SemiBold", 12, -0.06, 1.2, color)
    }
    
    func caption_02(_ color: Color? = nil) -> some View {
        styled("Pretendard-Medium", 12, -0.06, 1.2, color)
    }
    
    func caption_03(_ color: Color? = nil) -> some View {
        styled("Pretendard-Regular", 10, -0.05, 1.0, color)
    }
    
    @ViewBuilder
    private func styled(_ fontName: String, _ size: CGFloat, _ kerning: CGFloat, _ lineSpacing: CGFloat, _ color: Color?) -> some View {
        let base = self
            .font(.custom(fontName, size: size))
            .kerning(kerning)
            .lineSpacing(lineSpacing)
        
        if let color {
            base.foregroundStyle(color)
        } else {
            base
        }
    }
}
