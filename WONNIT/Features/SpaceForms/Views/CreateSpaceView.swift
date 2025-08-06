//
//  CreateSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI

struct CreateSpaceView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: CreateSpaceFormStep = .addressAndName
    @FocusState private var focusedField: String?
    @State private var formStore = FormStateStore()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
                .onTapGesture {
                    focusedField = nil
                }
            
            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing: 6) {
                    topBar
                    
                    formStepProgressBar
                }
                
                formContent
            }
            
            nextButton
        }
    }
    
    @ViewBuilder
    private var topBar: some View {
        HStack {
            backButton
            Spacer()
        }
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = nil
                }
        )
        .padding(16)
    }
    
    @ViewBuilder
    private var backButton: some View {
        Button {
            if let prev = currentStep.previous {
                withAnimation {
                    currentStep = prev
                }
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.left")
        }
        .foregroundStyle(Color.grey900)
        .font(.system(size: 18))
    }
    
    private var nextButton: some View {
        let isValid = currentStep.isStepValid(store: formStore)
        let isOptional = currentStep.isOptional
        
        return Button {
            if isValid {
                if let next = currentStep.next {
                    currentStep = next
                } else {
                    submitForm()
                }
            }
        } label: {
            Text(currentStep.next == nil ? "등록하기" : (isOptional ? "건너뛰기" : "다음으로"))
                .body_01(isValid ? .white : .grey300)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isValid ? Color.primaryPurple : .grey100)
                )
                .padding(.horizontal, 16)
        }
        .disabled(!isValid && !isOptional)
    }
    
    private var formStepProgressBar: some View {
        let steps = CreateSpaceFormStep.allCases
        let currentIndex = steps.firstIndex(of: currentStep) ?? 0
        
        return GeometryReader { geometry in
            let totalSpacing: CGFloat = CGFloat(steps.count - 1) * 7
            let capsuleWidth = (geometry.size.width - totalSpacing) / CGFloat(steps.count)
            
            HStack(spacing: 7) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Capsule()
                        .fill(index <= currentIndex ? Color.primaryPurple : Color.grey200)
                        .frame(width: capsuleWidth, height: 6)
                        .animation(.easeInOut(duration: 0.3), value: currentIndex)
                }
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 16)
    }
    
    private var formStepTitle: some View {
        HStack {
            Text(currentStep.sectionTitle)
                .title_01(.grey900)
            Spacer()
        }
    }
    
    private var formContent: some View {
        GeometryReader { geometry in
            ScrollView {
                ZStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            focusedField = nil
                        }
                    
                    VStack(spacing: 24) {
                        formStepTitle
                        
                        VStack(spacing: 32) {
                            ForEach(currentStep.components, id: \.id) { component in
                                FormRenderer.render(
                                    component,
                                    store: formStore,
                                    focusedField: $focusedField
                                )
                            }
                        }
                        
                        Spacer()
                            .frame(minHeight: geometry.size.height - 600)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 36)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private func submitForm() {
        print(formStore.values)
    }
}

#Preview {
    CreateSpaceView()
}
