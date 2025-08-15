//
//  ReviewReturnSpaceActionButtonView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct ReviewReturnSpaceActionButtonView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingReturnSpaceView: Bool = false
    
    let spaceId: UUID
    
    var body: some View {
        Button {
            isShowingReturnSpaceView = true
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
        .fullScreenCover(isPresented: $isShowingReturnSpaceView) {
            ReviewReturnSpaceView(spaceId: spaceId)
        }
    }
}

#Preview {
    let sampleSpace = Space.placeholder
    
    ReviewReturnSpaceActionButtonView(spaceId: sampleSpace.id)
}
