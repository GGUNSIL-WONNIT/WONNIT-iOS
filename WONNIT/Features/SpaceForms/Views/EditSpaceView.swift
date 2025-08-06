//
//  EditSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import SwiftUI

struct EditSpaceView: View {
    @State private var formStore = FormStateStore()
    @FocusState private var focusedField: String?
    
    init(spaceData: Space) {
        var initialState = FormStateStore()
        initialState.inject(from: spaceData)
        _formStore = State(initialValue: initialState)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 60) {
                ForEach(EditSpaceFormStep.allCases, id: \.id) { step in
                    VStack(alignment: .leading, spacing: 20) {
                        Text(step.title)
                            .title_01(.grey900)
                        
                        ForEach(step.components, id: \.id) { component in
                            FormRenderer.render(
                                component,
                                store: formStore,
                                focusedField: $focusedField
                            )
                        }
                    }
                }
            }
            .padding(.horizontal)
            .paddedForTabBar()
        }
    }
}

#Preview {
    EditSpaceView(spaceData: .placeholder)
}
