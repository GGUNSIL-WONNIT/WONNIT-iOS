//
//  DonePageWithImageView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct DonePageWithImageView<Content: View>: View {
    @State private var showConfetti = false
    
    let content: Content
    let showConfettiOnAppear: Bool
    
    init(@ViewBuilder content: () -> Content, showConfettiOnAppear: Bool = true) {
        self.content = content()
        self.showConfettiOnAppear = showConfettiOnAppear
    }
    
    var body: some View {
        ZStack {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            
            ConfettiView(isEmitting: $showConfetti)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = showConfettiOnAppear
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showConfetti = false
                }
            }
        }
    }
}

#Preview {
    DonePageWithImageView {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                Image("icon/status/rentSuccess")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                
                Text("공간 대여가 완료되었어요")
                    .title_01(.grey900)
                
                HStack(spacing: 0) {
                    Text("공간 사용 전과 후에는").body_05(.grey700)
                    Text(" 꼭 사진을 찍어 주세요!").body_05(.grey900)
                }
                .padding(.top, 12)
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
            Button {
                
            } label: {
                Text("홈으로 가기")
                    .body_01(.white)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primaryPurple)
                    )
            }
        }
    }
}
