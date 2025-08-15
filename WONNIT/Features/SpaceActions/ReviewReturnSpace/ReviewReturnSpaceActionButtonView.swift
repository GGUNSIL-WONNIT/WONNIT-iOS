//
//  ReviewReturnSpaceActionButtonView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct ReviewReturnSpaceActionButtonView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingReviewReturnSpaceView: Bool = false
    
    let spaceId: UUID
    
    var body: some View {
        Button {
            isShowingReviewReturnSpaceView = true
        } label: {
            Text("반납 확인하기")
                .body_05(.primaryPurple)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: .init(lineWidth: 1))
                )
        }
        .fullScreenCover(isPresented: $isShowingReviewReturnSpaceView) {
            ReviewReturnSpaceView(spaceId: spaceId)
        }
    }
}

#Preview {
    let sampleSpace = Space.placeholder
    
    ReviewReturnSpaceActionButtonView(spaceId: sampleSpace.id)
}
