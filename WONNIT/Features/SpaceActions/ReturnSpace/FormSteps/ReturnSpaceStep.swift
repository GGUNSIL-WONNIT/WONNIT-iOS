//
//  ReturnSpaceStep.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import Foundation
import SwiftUI

enum ReturnSpaceStep: FormStep {
    case before
    case after
    case result
    
    var sectionTitle: String? {
        switch self {
        case .before:
            return"사용 전 공간 사진을\n등록해주세요"
        case .after:
            return"사용 후 공간 사진을\n등록해주세요"
        case .result:
            return nil
        }
    }
    
    var components: [FormComponent] {
        switch self {
        case .before:
            return [
                .imageUploaderSimple(config: .init(
                    id: "before"
                ))
            ]
            
        case .after:
            return [
                .imageUploaderSimple(config: .init(
                    id: "after"
                ))
            ]
            
        case .result:
            return [
                .imageComparison(config: .init(
                    id: "result",
                    spaceImagesComparisonBeforeKey: "before",
                    spaceImagesComparisonAfterKey: "after"
                ))
            ]
        }
    }
    
    var buttons: [FormStepButton]? {
        switch self {
        case .result:
            return [.init(label: "다시 등록하기", style: .outlined)]
        default:
            return nil
        }
    }
    
    var submitButtonTitle: String { "마치기" }
    
    var hideDefaultButton: Bool {
        switch self {
        default:
            return false
        }
    }
}
