//
//  DonePageView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct DonePageView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showConfetti = false
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    
    let message: String
    let imageName: String
    let showConfettiOnAppear: Bool
    
    init(message: String = "새로운 공간이\n등록되었습니다!", imageName: String = "checkmark.circle", showConfettiOnAppear: Bool = true, isLoading: Binding<Bool> = .constant(false), errorMessage: Binding<String?> = .constant(nil)) {
        self.message = message
        self.imageName = imageName
        self.showConfettiOnAppear = showConfettiOnAppear
        self._isLoading = isLoading
        self._errorMessage = errorMessage
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if isLoading {
                ProgressView("처리 중...")
            } else if let errorMessage {
                VStack(spacing: 24) {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 96, height: 96)
                        .foregroundColor(.primaryPurple)
                        .symbolEffect(.bounce.down.byLayer, options: .nonRepeating)
                    
                    
                    Text("작업에 실패했어요.")
                        .head_02(.grey900)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                
                VStack {
                    ErrorMessageView(
                        title: "오류 메시지",
                        message: errorMessage
                    )
                    .padding()
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        FormStepButtonView(config: .init(label: "취소하기"), isValid: .constant(true))
                    }
                }
            } else {
                VStack(spacing: 24) {
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: 96, height: 96)
                        .foregroundColor(.primaryPurple)
                        .symbolEffect(.bounce.down.byLayer, options: .nonRepeating)
                    
                    
                    Text(message)
                        .head_02(.grey900)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                
                VStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        FormStepButtonView(config: .init(label: "완료"), isValid: .constant(true))
                    }
                }
            }
            
            if let errorMessage {
                ErrorMessageView(
                    title: "오류 메시지",
                    message: errorMessage
                )
                .padding()
            }
            
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
    DonePageView()
}
