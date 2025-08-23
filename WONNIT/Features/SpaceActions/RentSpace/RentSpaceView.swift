//
//  RentSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct RentSpaceView: View {
    @Environment(\.dismiss) private var dismiss
    
    let spaceId: String
    
    var body: some View {
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
                    dismiss()
                } label: {
                    Text("이전으로")
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
}
