//
//  ReturnSpaceActionButtonView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/14/25.
//

import SwiftUI

struct ReturnSpaceActionButtonView: View {
    @State private var isShowingReturnSpaceView: Bool = false
    
    let spaceId: UUID
    
    var body: some View {
        Button {
            isShowingReturnSpaceView = true
        } label: {
            Text("반납하기")
                .body_05(.primaryPurple)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: .init(lineWidth: 1))
                )
        }
        .fullScreenCover(isPresented: $isShowingReturnSpaceView) {
            ReturnSpaceView(spaceId: spaceId)
        }
    }
}

#Preview {
    let sampleSpace = Space.placeholder
    
    ReturnSpaceActionButtonView(spaceId: sampleSpace.id)
}
