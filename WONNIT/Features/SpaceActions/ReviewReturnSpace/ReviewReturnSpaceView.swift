//
//  ReviewReturnSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI
import Kingfisher

private enum DoneMessage {
    case reject
    case approve
    
    var message: String {
        switch self {
        case .reject:
            return "반납이 반려되었습니다!"
        case .approve:
            return "반납이 승인되었습니다!"
        }
    }
    
    var imageName: String {
        switch self {
        case .reject:
            return "xmark.circle"
        case .approve:
            return "checkmark.circle"
        }
    }
    
    var showConfettiOnAppear: Bool {
        switch self {
        case .reject:
            return false
        case .approve:
            return true
        }
    }
}

struct ReviewReturnSpaceView: View {
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.dismiss) private var dismiss

    let space: Space
    
    @State private var selectedImageIndex = 0
    @State private var doneMessage: DoneMessage?
    @State private var showDoneView: Bool = false
    @State private var errorMessage: String?
    
    var body: some View {
        if showDoneView {
            if let doneMessage {
                DonePageView(message: doneMessage.message, imageName: doneMessage.imageName, showConfettiOnAppear: doneMessage.showConfettiOnAppear)
            }
        } else {
            ZStack(alignment: .top) {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        VStack(spacing: 6) {
                            topBar
                        }
                        content
                    }
                    
                    bottomButtons
                        .padding(.vertical, 8)
                        .background(Color.white)
                }
                
                if let errorMessage {
                    ErrorMessageView(title: "오류 발생", message: errorMessage)
                        .padding()
                }
            }
        }
    }
    
    @ViewBuilder
    private var topBar: some View {
        HStack {
            backButton
            Spacer()
        }
        .padding(16)
    }
    
    @ViewBuilder
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .contentShape(Rectangle())
        }
        .foregroundStyle(Color.grey900)
        .font(.system(size: 18))
    }
    
    private var bottomButtons: some View {
        return VStack(spacing: 12) {
            Button {
                Task {
                    do {
                        try await rejectReturnRequest()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("반납 반려")
                    .body_01(.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primaryPurple, lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
            }
            
            Button {
                Task {
                    do {
                        try await approveReturnRequest()
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("반납 확인")
                    .body_01(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.primaryPurple)
                    )
                    .padding(.horizontal, 16)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 24) {
            HStack {
                if let similarity = space.similarity {
                    Text("AI 이미지 분석 결과\n대여 이전 상태와 \(String(format: "%.0f", similarity))% 일치해요")
                        .title_01(.grey900)
                } else {
                    Text("AI 이미지 분석 결과")
                        .title_01(.grey900)
                }
                Spacer()
            }
            
//            TabView(selection: $selectedImageIndex) {
//                ForEach(Array([space.beforeImgUrl, space.afterImgUrl].enumerated()), id: \.offset) { index, url in
//                    GeometryReader { geometry in
//                        KFImage(url)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: geometry.size.width, height: geometry.size.width * 0.75)
//                            .clipShape(RoundedRectangle(cornerRadius: 8))
//                    }
//                    .tag(index)
//                    .overlay(alignment: .topLeading) {
//                        ColoredTagView(label: index == 0 ? "사용 전" : "사용 후")
//                            .padding(10)
//                    }
//                }
//            }
//            .frame(height: UIScreen.main.bounds.width * 0.75 - 16)
//            .tabViewStyle(.page)
            
            if let after = space.afterImgUrl, let url = URL(string: after) {
                KFImage(url)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(alignment: .topLeading) {
                        ColoredTagView(label: "사용 후")
                            .padding(10)
                    }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @MainActor
    private func rejectReturnRequest() async throws {
        let client = try await WONNITClientAPIService.shared.client()
        let response = try await client.returnReject(path: .init(spaceId: space.id), query: .init(userId: appSettings.selectedTestUserID))
        
        switch response {
        case .noContent:
            doneMessage = .reject
            
            withAnimation {
                showDoneView = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                dismiss()
            }
        default:
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(response)"])
        }
    }
    
    @MainActor
    private func approveReturnRequest() async throws {
        let client = try await WONNITClientAPIService.shared.client()
        let response = try await client.returnApprove(path: .init(spaceId: space.id), query: .init(userId: appSettings.selectedTestUserID))
        
        switch response {
        case .noContent:
            doneMessage = .approve
            
            withAnimation {
                showDoneView = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                dismiss()
            }
        default:
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(response)"])
        }
    }
}
