//
//  SpaceItemModel.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/13/25.
//

import Foundation

enum SpaceItem: String, CaseIterable, Codable {
    case airConditioner = "air_conditioner"
    case chair
    case desk
    case drum
    case microphone
    case mirror
    case monitor
    case piano
    case projector
    case speaker
    case spotlight
    case stage
    case whiteboard
    
    var displayLabel: String {
        switch self {
        case .airConditioner: return "에어컨"
        case .chair: return "의자"
        case .desk: return "책상"
        case .drum: return "드럼"
        case .microphone: return "마이크"
        case .mirror: return "거울"
        case .monitor: return "모니터"
        case .piano: return "피아노"
        case .projector: return "프로젝터"
        case .speaker: return "스피커"
        case .spotlight: return "스팟라이트"
        case .stage: return "무대"
        case .whiteboard: return "화이트보드"
        }
    }
}
