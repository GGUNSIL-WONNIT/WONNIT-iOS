//
//  MultiStepFormView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct MultiStepFormView<Step: FormStep>: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep: Step
    
    @State private var formStore: FormStateStore
    
    @State private var transitionDirection: Edge = .trailing
    @State private var showDonePage = false
    
    private let initialStep: Step
    private let donePageView: AnyView
    private let onSubmit: (FormStateStore) -> Void
    private let onCustomButtonTap: ((String, FormStateStore, FormActions) -> Void)?
    
    struct FormActions {
        let goToStep: (Step) -> Void
        let submit: () -> Void
    }
    
    init(
        initialStep: Step,
        donePageView: some View,
        store: FormStateStore,
        onSubmit: @escaping (FormStateStore) -> Void,
        onCustomButtonTap: ((String, FormStateStore, FormActions) -> Void)? = nil
    ) {
        self._currentStep = State(initialValue: initialStep)
        self.initialStep = initialStep
        self.donePageView = AnyView(donePageView)
        self.formStore = store
        self.onSubmit = onSubmit
        self.onCustomButtonTap = onCustomButtonTap
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
                .onTapGesture {
                    formStore.blur()
                }
            
            if !showDonePage {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(spacing: 6) {
                        topBar
                        formStepProgressBar
                    }
                    formContent
                }
                
                bottomButtons
                    .padding(.vertical, 8)
                    .background(Color.white)
            } else {
                donePageView
            }
        }
        .environment(formStore)
    }
    
    @ViewBuilder
    private var topBar: some View {
        HStack {
            backButton
            Spacer()
            debugPlaceholderButton()
        }
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    formStore.blur()
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
    
    @ViewBuilder
    private func debugPlaceholderButton() -> some View {
        Button {
            formStore.fillWithDebugPlaceholderData()
        } label: {
            Image(systemName: "ladybug")
                .contentShape(Rectangle())
        }
    }
    
    private var bottomButtons: some View {
        let isValid = currentStep.isStepValid(store: formStore)
        let isOptional = currentStep.isOptional
        
        return VStack(spacing: 12) {
            if let customButtons = currentStep.buttons, onCustomButtonTap != nil {
                VStack(spacing: 12) {
                    ForEach(customButtons, id: \.label) { buttonConfig in
                        Button {
                            let actions = FormActions(
                                goToStep: { step in self.goToStep(step) },
                                submit: { self.submitForm() }
                            )
                            onCustomButtonTap?(buttonConfig.label, formStore, actions)
                        } label: {
                            Text(buttonConfig.label)
                                .body_01(buttonConfig.style == .primary ? .white : .primaryPurple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(buttonConfig.style == .primary ? Color.primaryPurple : .white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.primaryPurple, lineWidth: buttonConfig.style == .outlined ? 1 : 0)
                                )
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Button {
                if isValid || isOptional {
                    if let next = currentStep.next {
                        goToStep(next)
                    } else {
                        submitForm()
                    }
                }
            } label: {
                Text(currentStep.next == nil ? currentStep.submitButtonTitle : (isOptional ? "건너뛰기" : "다음으로"))
                    .body_01((isValid || isOptional) ? .white : .grey300)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill((isValid || isOptional) ? Color.primaryPurple : .grey100)
                    )
                    .padding(.horizontal, 16)
            }
            .disabled(!isValid && !isOptional)
        }
    }
    
    private var formStepProgressBar: some View {
        let steps = Array(Step.allCases)
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
    
    private var formContent: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ScrollView {
                    ZStack {
                        Color.clear
                            .contentShape(Rectangle())
                            .onTapGesture {
                                formStore.blur()
                            }
                        
                        ZStack {
                            ForEach(Array(Step.allCases), id: \.id) { step in
                                if step == currentStep {
                                    VStack(spacing: 24) {
                                        if let title = step.sectionTitle {
                                            HStack {
                                                Text(title)
                                                    .title_01(.grey900)
                                                Spacer()
                                            }
                                        }
                                        
                                        VStack(spacing: 32) {
                                            ForEach(step.components, id: \.id) { component in
                                                FormRenderer.render(
                                                    component,
                                                    store: formStore
                                                )
                                                .id(component.id)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.top, 36)
                                    .padding(.bottom, 386)
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
                    .id("topAnchor")
                }
                .onChange(of: currentStep) { _, newStep in
                    withAnimation {
                        proxy.scrollTo("topAnchor", anchor: .top)
                    }
                }
                .onChange(of: formStore.focusedID) { _, newID in
                    guard let newID = newID else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            proxy.scrollTo(newID, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    private func goToStep(_ step: Step) {
        let allCases = Array(Step.allCases)
        let currentIndex = allCases.firstIndex(of: currentStep) ?? 0
        let nextIndex = allCases.firstIndex(of: step) ?? 0
        
        transitionDirection = nextIndex > currentIndex ? .trailing : .leading
        
        withAnimation(.easeInOut(duration: 0.35)) {
            currentStep = step
        }
    }
    
    private func submitForm() {
        onSubmit(formStore)
        withAnimation {
            showDonePage = true
        }
    }
}
