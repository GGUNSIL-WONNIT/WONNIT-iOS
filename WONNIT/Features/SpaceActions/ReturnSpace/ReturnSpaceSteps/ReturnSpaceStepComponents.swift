//
//  ReturnSpaceStepComponents.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import Foundation

extension ReturnSpaceStep {
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
}
