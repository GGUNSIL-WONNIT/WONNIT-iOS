//
//  RentSpaceActionButtonView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct RentSpaceActionButtonView: View {
    @State private var isShowingRentSpaceView: Bool = false
    
    let spaceId: UUID
    let isAvailable: Bool
    
    var body: some View {
        Button {
            isShowingRentSpaceView = true
        } label: {
            Text(isAvailable ? "공간 대여하기" : "지금은 대여할 수 없어요")
                .body_01(isAvailable ? .white : .grey300)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isAvailable ? Color.primaryPurple : .grey100)
                )
        }
        .fullScreenCover(isPresented: $isShowingRentSpaceView) {
            RentSpaceView(spaceId: spaceId)
        }
        .buttonStyle(.plain)
        .disabled(!isAvailable)
    }
}

#Preview {
    let sampleSpace = Space.placeholder
    
    RentSpaceActionButtonView(spaceId: sampleSpace.id, isAvailable: sampleSpace.status == .available)
}
