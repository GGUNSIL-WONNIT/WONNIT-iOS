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
                    ctaButton
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

    private var ctaButton: some View {
        Button(action: {
            // TODO: Impl. Navigation
        }) {
            HStack(spacing: 2) {
                Text("내 주변 공간 보러가기")
                    .caption_02()
                    .foregroundStyle(Color.grey900)
                Image(systemName: "chevron.right")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.grey900)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HeroView()
}
