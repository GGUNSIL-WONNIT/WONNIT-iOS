//
//  CreateSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI

struct CreateSpaceView: View {
    var body: some View {
        MultiStepFormView(
            initialStep: CreateSpaceFormStep.addressAndName,
            donePageView: DonePageView(),
            onSubmit: { formStore in
                print("Submit: \(formStore)")
            }
        )
    }
}

#Preview {
    CreateSpaceView()
}
