//
//  FormStepButtonView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct FormStepButtonView: View {
    let config: FormStepButton
    @Binding var isValid: Bool
    
    init(config: FormStepButton = .init(), isValid: Binding<Bool> = .constant(false)) {
        self.config = config
        self._isValid = isValid
    }
    
    var body: some View {
        Text(config.label)
            .body_01(isValid ? (config.style == .primary ? Color.white : .primaryPurple) : .grey300)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(config.style == .primary ? (isValid ? Color.primaryPurple : .grey100) : .white)
                    .stroke(config.style == .outlined ? (isValid ? Color.primaryPurple : .grey100) : .white)
            )
            .padding(.horizontal, 16)
    }
}

#Preview {
    @Previewable @State var isValid: Bool = false
    let config1 = FormStepButton()
    let config2 = FormStepButton(style: .outlined)
    
    FormStepButtonView(config: config1, isValid: $isValid)
    FormStepButtonView(config: config2, isValid: $isValid)
    
    Button {
        isValid.toggle()
    } label: {
        Text("Toggle Valid")
    }
}
