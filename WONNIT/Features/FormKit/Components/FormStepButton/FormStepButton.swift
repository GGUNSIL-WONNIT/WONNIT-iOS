//
//  FormStepButton.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import Foundation

struct FormStepButton {
    enum Style {
        case primary
        case outlined
    }
    
    var label: String = "다음으로"
    var style: Style = .primary
}
