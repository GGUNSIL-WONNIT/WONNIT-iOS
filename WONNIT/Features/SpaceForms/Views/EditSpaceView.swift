//
//  EditSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import SwiftUI

struct EditSpaceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var formStore = FormStateStore()
    @FocusState private var focusedField: String?
    
    @State private var showDonePage = false
    
    init(spaceData: Space) {
        let initialState = FormStateStore()
        initialState.inject(from: spaceData)
        _formStore = State(initialValue: initialState)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .onTapGesture {
                    focusedField = nil
                }
            if !showDonePage {
                ScrollView {
                    ZStack {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                focusedField = nil
                            }
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
                    }
                    .padding(.top, safeAreaInsets.top + 72)
                    .padding(.horizontal)
                    .paddedForTabBar()
                }
                
                topBar
                    .zIndex(1)
            } else {
                DonePageView(message: "수정이 완료되었습니다!")
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
    
    @ViewBuilder
    private var topBar: some View {
        ZStack {
            Text("수정하기")
                .body_03(.grey900)
            HStack {
                backButton
                Spacer()
                doneButton
            }
        }
        .padding(16)
        .padding(.top, safeAreaInsets.top)
        .background(
            Color.white
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
        )
    }
    
    @ViewBuilder
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("취소")
                .body_04(.grey900)
        }
        .foregroundStyle(Color.grey900)
        .font(.system(size: 18))
    }
    
    @ViewBuilder
    private var doneButton: some View {
        Button {
            withAnimation {
                showDonePage = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                dismiss()
            }
        } label: {
            Text("완료")
                .body_04(.grey900)
        }
        .foregroundStyle(Color.grey900)
        .font(.system(size: 18))
    }
}

#Preview {
    EditSpaceView(spaceData: .placeholder)
}
