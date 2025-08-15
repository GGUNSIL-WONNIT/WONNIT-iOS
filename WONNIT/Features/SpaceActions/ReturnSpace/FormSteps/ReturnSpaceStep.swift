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
    
    var sectionTitle: String {
        switch self {
        case .before:
            return"사용 전 공간 사진을\n등록해주세요"
        case .after:
            return"사용 후 공간 사진을\n등록해주세요"
        case .result:
            return"AI 분석 결과"
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
                .description(id: "result", text: "결과")
            ]
        }
    }
    
    var buttons: [FormStepButton]? {
        switch self {
        case .result:
            return [.init(label: "다시 등록하기", style: .outlined), .init(label: "마치기")]
        default:
            return nil
        }
    }
    
    var submitButtonTitle: String { "마치기" }
}
