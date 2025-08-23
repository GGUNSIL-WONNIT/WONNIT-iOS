//
//  ReturnSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import SwiftUI

struct ReturnSpaceView: View {
    let spaceId: String
    
    @State private var formStore = FormStateStore()
    
    var body: some View {
        MultiStepFormView(
            initialStep: ReturnSpaceStep.before,
            donePageView: DonePageView(message: "반납이 요청되었습니다!", imageName: "paperplane"),
            store: formStore,
            onSubmit: { formStore in
                print("Submit\nspaceId: \(spaceId)\nstore: \(formStore)")
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
}

#Preview {
    let sampleSpace = Space.placeholder
    
    ReturnSpaceView(spaceId: sampleSpace.id)
}
