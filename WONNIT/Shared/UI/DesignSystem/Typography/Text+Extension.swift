//
//  Font+Extension.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

extension Text {
    // title-01: 24pt, semibold, lineHeight 140%, letterSpacing -0.5%
    // kerning: 24 * (-0.5 / 100) = -0.12
    // lineSpacing: 24 * 1.4 - 24 = 9.6
    func title_01() -> some View {
        self.font(.custom("Pretendard-SemiBold", size: 24))
            .kerning(-0.12)
            .lineSpacing(9.6)
    }
    
    // title-02: 24pt, medium, lineHeight 140%, letterSpacing -0.5%
    // kerning: 24 * (-0.5 / 100) = -0.12
    // lineSpacing: 24 * 1.4 - 24 = 9.6
    func title_02() -> some View {
        self.font(.custom("Pretendard-Medium", size: 24))
            .kerning(-0.12)
            .lineSpacing(9.6)
    }

    // head-01: 20pt, semibold, lineHeight 140%, letterSpacing -0.5%
    // kerning: 20 * (-0.5 / 100) = -0.10
    // lineSpacing: 20 * 1.4 - 20 = 8.0
    func head_01() -> some View {
        self.font(.custom("Pretendard-SemiBold", size: 20))
            .kerning(-0.10)
            .lineSpacing(8.0)
    }
    
    // head-02: 20pt, regular, lineHeight 140%, letterSpacing -0.5%
    // kerning: 20 * (-0.5 / 100) = -0.10
    // lineSpacing: 20 * 1.4 - 20 = 8.0
    func head_02() -> some View {
        self.font(.custom("Pretendard-Regular", size: 20))
            .kerning(-0.10)
            .lineSpacing(8.0)
    }
    
    // body-01: 18pt, semibold, lineHeight 140%, letterSpacing -0.5%
    // kerning: 18 * (-0.5 / 100) = -0.09
    // lineSpacing: 18 * 1.4 - 18 = 7.2
    func body_01() -> some View {
        self.font(.custom("Pretendard-SemiBold", size: 18))
            .kerning(-0.09)
            .lineSpacing(7.2)
    }
    
    // body-02: 18pt, medium, lineHeight 140%, letterSpacing -0.5%
    // kerning: 18 * (-0.5 / 100) = -0.09
    // lineSpacing: 18 * 1.4 - 18 = 7.2
    func body_02() -> some View {
        self.font(.custom("Pretendard-Medium", size: 18))
            .kerning(-0.09)
            .lineSpacing(7.2)
    }
    
    // body-03: 16pt, semibold, lineHeight 150%, letterSpacing -0.5%
    // kerning: 16 * (-0.5 / 100) = -0.08
    // lineSpacing: 16 * 1.5 - 16 = 8.0
    func body_03() -> some View {
        self.font(.custom("Pretendard-SemiBold", size: 16))
            .kerning(-0.08)
            .lineSpacing(8.0)
    }
    
    // body-04: 16pt, meduim, lineHeight 150%, letterSpacing -0.5%
    // kerning: 16 * (-0.5 / 100) = -0.08
    // lineSpacing: 16 * 1.5 - 16 = 8.0
    func body_04() -> some View {
        self.font(.custom("Pretendard-Medium", size: 16))
            .kerning(-0.08)
            .lineSpacing(8.0)
    }
    
    // body-05: 14pt, medium, lineHeight 150%, letterSpacing -0.5%
    // kerning: 14 * (-0.5 / 100) = -0.07
    // lineSpacing: 14 * 1.5 - 14 = 7.0
    func body_05() -> some View {
        self.font(.custom("Pretendard-Medium", size: 14))
            .kerning(-0.07)
            .lineSpacing(7.0)
    }
    
    // body-06: 14pt, regular, lineHeight 150%, letterSpacing -0.5%
    // kerning: 14 * (-0.5 / 100) = -0.07
    // lineSpacing: 14 * 1.5 - 14 = 7.0
    func body_06() -> some View {
        self.font(.custom("Pretendard-Regular", size: 14))
            .kerning(-0.07)
            .lineSpacing(7.0)
    }
    
    // Caption
    // caption-01: 12pt, semibold, lineHeight 110%, letterSpacing -0.5%
    // kerning: 12 * (-0.5 / 100) = -0.06
    // lineSpacing: 12 * 1.1 - 12 = 1.2
    func caption_01() -> some View {
        self.font(.custom("Pretendard-SemiBold", size: 12))
            .kerning(-0.06)
            .lineSpacing(1.2)
    }
    
    // caption-02: 12pt, medium, lineHeight 110%, letterSpacing -0.5%
    // kerning: 12 * (-0.5 / 100) = -0.06
    // lineSpacing: 12 * 1.1 - 12 = 1.2
    func caption_02() -> some View {
        self.font(.custom("Pretendard-Medium", size: 12))
            .kerning(-0.06)
            .lineSpacing(1.2)
    }
    
    // caption-03: 10pt, regular, lineHeight 110%, letterSpacing -0.5%
    // kerning: 10 * (-0.5 / 100) = -0.05
    // lineSpacing: 10 * 1.1 - 10 = 1.0
    func caption_03() -> some View {
        self.font(.custom("Pretendard-Regular", size: 10))
            .kerning(-0.05)
            .lineSpacing(1.0)
    }
}
