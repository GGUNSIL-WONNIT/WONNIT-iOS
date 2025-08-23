//
//  RentSpaceActionButtonView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct RentSpaceActionButtonView: View {
    @Environment(AppSettings.self) private var appSettings
    
    @State private var isShowingRentSpaceView: Bool = false
    @State private var isRenting: Bool = false
    @State private var errorMessage: String? = nil
    @State private var showErrorSheet: Bool = false
    
    let spaceId: String
    let isAvailable: Bool
    var refetch: (() -> Void)?
    
    var body: some View {
        Button {
            rentSpace()
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
        .fullScreenCover(isPresented: $isShowingRentSpaceView, onDismiss: {
            refetch?()
        }) {
            RentSpaceView(spaceId: spaceId)
        }
        .buttonStyle(.plain)
        .disabled(!isAvailable)
    }
    
    private func rentSpace() {
        guard !isRenting else { return }
        isRenting = true
        errorMessage = nil
        
        Task {
            do {
                let client = try await WONNITClientAPIService.shared.client()
                let resp = try await client.rentSpace(
                    path: .init(spaceId: spaceId),
                    query: .init(userId: appSettings.selectedTestUserID)
                )
                
                switch resp {
                case .created:
                    isRenting = false
                    isShowingRentSpaceView = true
                case let .undocumented(statusCode, _):
                    isRenting = false
                    errorMessage = "오류 코드 \(statusCode)"
                    showErrorSheet = true
                }
            } catch {
                isRenting = false
                errorMessage = error.localizedDescription
                showErrorSheet = true
            }
        }
    }

}

#Preview {
    let sampleSpace = Space.placeholder
    
    RentSpaceActionButtonView(spaceId: sampleSpace.id, isAvailable: sampleSpace.status == .available)
}
