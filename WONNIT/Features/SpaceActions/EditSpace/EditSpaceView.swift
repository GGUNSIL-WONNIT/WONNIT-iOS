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
    
    @State private var showDonePage = false
    @State private var spaceData: Space?
    private let spaceId: String
    
    init(spaceId: String) {
        self.spaceId = spaceId
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .onTapGesture {
                    formStore.blur()
                }
            if !showDonePage {
                ScrollView {
                    ZStack {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                formStore.blur()
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
        .task {
            await fetchSpaceDetails()
        }
    }
    
    private func fetchSpaceDetails() async {
        do {
            let client = try await WONNITClientAPIService.shared.client()
            let response = try await client.getSpaceDetail(path: .init(spaceId: spaceId))
            let spaceDTO = try response.ok.body.json
            let space = Space(from: spaceDTO)
            self.spaceData = space
            formStore.inject(from: space)
        } catch {
            // Handle error
            print("Failed to fetch space details: \(error)")
        }
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
                    formStore.blur()
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
    EditSpaceView(spaceId: "0198d312-f855-3efc-3f89-fc285f50fa81")
}
