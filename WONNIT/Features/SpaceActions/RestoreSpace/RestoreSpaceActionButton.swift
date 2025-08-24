//
//  RestoreSpaceActionButton.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/24/25.
//

import SwiftUI

struct RestoreSpaceActionButton: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSettings.self) private var appSettings
    
    @State private var showRestoreConfirmation: Bool = false
    
    let spaceId: String
    var refetch: (() -> Void)?
    @Binding var errorMessage: String?
    
    var body: some View {
        Button {
            showRestoreConfirmation = true
        } label: {
            Text("공간 재등록하기")
                .body_05(.primaryPurple)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: .init(lineWidth: 1))
                )
        }
        .alert("선택한 공간을 다시 등록하시겠어요?", isPresented: $showRestoreConfirmation) {
            Button("확인") {
                restoreSelectedSpaces()
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("다시 대여 가능한 상태로 변경합니다.")
        }
    }
    
    private func restoreSelectedSpaces() {
        Task {
            do {
                let client = try await WONNITClientAPIService.shared.client()
                _ = try await client.reRegistration(
                    path: .init(spaceId: spaceId),
                    query: .init(userId: appSettings.selectedTestUserID)
                )
                
            } catch {
                errorMessage = "공간을 재등록할 수 없습니다.\n\(error.localizedDescription)"
                return
            }
            
            refetch?()
        }
    }
}
