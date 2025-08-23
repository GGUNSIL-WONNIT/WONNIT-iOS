//
//  ReturnSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct ReturnSpaceView: View {
    @Environment(AppSettings.self) private var appSettings
    
    let spaceId: String
    
    @State private var isSubmitting = false
    @State private var errorMessage: String?
    
    @State private var formStore = FormStateStore()
    
    var body: some View {
        MultiStepFormView(
            initialStep: ReturnSpaceStep.before,
            donePageView: DonePageView(message: "반납이 요청되었습니다!", imageName: "paperplane", showConfettiOnAppear: false, isLoading: $isSubmitting, errorMessage: $errorMessage),
            store: formStore,
            onSubmit: { store in
                Task {
                    await handleSubmit(formStore: store)
                }
            },
            onCustomButtonTap: { buttonLabel, formStore, actions in
                if buttonLabel == "다시 등록하기" {
                    actions.goToStep(.before)
                } else if buttonLabel == "마치기" {
                    actions.submit()
                }
            }
        )
    }
    
    @MainActor
    private func handleSubmit(formStore: FormStateStore) async {
        isSubmitting = true
        errorMessage = nil
        
        do {
            guard let beforeImage = (formStore.imageValues["before"] ?? []).first else { throw MappingError.missingRequiredData(field: "이전 사진") }
            guard let afterImage = (formStore.imageValues["after"] ?? []).first else { throw MappingError.missingRequiredData(field: "이후 사진") }
           
            let beforeImageURL = try await ImageUploaderService.shared.uploadImage(beforeImage)
            let afterImageURL = try await ImageUploaderService.shared.uploadImage(afterImage)
            
            try await requestReturn()
            
        } catch {
            errorMessage = "오류: \(error.localizedDescription)"
        }
        
        isSubmitting = false
    }
    
    @MainActor
    private func requestReturn() async throws {
        let client = try await WONNITClientAPIService.shared.client()
//        let requestBody = try Components.Schemas.SpaceSaveRequest        
        let response = try await client.returnRequest(path: .init(spaceId: spaceId), query: .init(userId: appSettings.selectedTestUserID))
        
        switch response {
        case .noContent:
            errorMessage = nil
        default:
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(response)"])
        }
    }
}

#Preview {
    let sampleSpace = Space.placeholder
    
    ReturnSpaceView(spaceId: sampleSpace.id)
}
