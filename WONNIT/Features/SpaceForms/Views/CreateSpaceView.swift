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
    @State private var transitionDirection: Edge = .trailing
    @State private var showDonePage = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
                .onTapGesture {
                    focusedField = nil
                }
            
            if !showDonePage {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 6) {
                        topBar
                        
                        formStepProgressBar
                    }
                    
                    formContent
                }
                
                nextButton
                    .padding(.vertical, 8)
                    .background(Color.white)
            } else {
                DonePageView()
            }
        }
        .onChange(of: focusedField) {
            print(focusedField ?? "nil")
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
                goToStep(prev)
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.left")
                .contentShape(Rectangle())
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
                    goToStep(next)
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
            let availableWidth = max(geometry.size.width - totalSpacing, 0)
            let capsuleWidth = steps.count > 0 ? availableWidth / CGFloat(steps.count) : 0
            
            HStack(spacing: 7) {
                ForEach(0..<steps.count, id: \.self) { index in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.grey200)
                            .frame(width: capsuleWidth, height: 6)
                        
                        Capsule()
                            .fill(Color.primaryPurple)
                            .frame(width: index <= currentIndex ? capsuleWidth : 0, height: 6)
                            .animation(.interactiveSpring(response: 0.45, dampingFraction: 0.85, blendDuration: 0.2), value: currentStep)
                    }
                    .clipped()
                }
            }
        }
        .frame(height: 6)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Main form content
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
                    
                    ZStack {
                        ForEach(CreateSpaceFormStep.allCases, id: \.self) { step in
                            if step == currentStep {
                                VStack(spacing: 24) {
                                    HStack {
                                        Text(step.sectionTitle)
                                            .title_01(.grey900)
                                        Spacer()
                                    }
                                    
                                    VStack(spacing: 32) {
                                        ForEach(step.components, id: \.id) { component in
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
                                .transition(.asymmetric(
                                    insertion: .move(edge: transitionDirection).combined(with: .opacity),
                                    removal: .move(edge: transitionDirection == .trailing ? .leading : .trailing).combined(with: .opacity)
                                ))
                            }
                        }
                    }
                    .animation(.interactiveSpring(response: 0.45, dampingFraction: 0.85, blendDuration: 0.2), value: currentStep)
                }
            }
        }
    }
    
    // MARK: - Helper functions
    private func goToStep(_ step: CreateSpaceFormStep) {
        let currentIndex = CreateSpaceFormStep.allCases.firstIndex(of: currentStep) ?? 0
        let nextIndex = CreateSpaceFormStep.allCases.firstIndex(of: step) ?? 0
        
        transitionDirection = nextIndex > currentIndex ? .trailing : .leading
        
        withAnimation(.easeInOut(duration: 0.35)) {
            currentStep = step
        }
    }
    
    private func submitForm() {
        print(formStore.values)
        
        withAnimation {
            showDonePage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            dismiss()
        }
        
    }
}

#Preview {
    CreateSpaceView()
}
