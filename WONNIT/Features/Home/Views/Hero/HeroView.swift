//
//  HeroView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct HeroView: View {
    var body: some View {
        ZStack(alignment: .trailing) {
            Image("home/hero_img")

            HStack {
                VStack(alignment: .leading, spacing: 12) {
                    heroTitleSection
                    HeroCTAButtonView()
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
    }

    @ViewBuilder
    private var heroTitleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("나에게 필요한")
                .title_01()

            (
                Text("노원구 ").title_01_text() +
                Text("유휴공간").title_01_text().foregroundStyle(Color.primaryPurple) +
                Text(",").title_01_text()
            )
            .lineSpacing(9.6)

            Text("워닛에서 찾아보세요")
                .title_01()
        }
    }
}

#Preview {
    HeroView()
}
