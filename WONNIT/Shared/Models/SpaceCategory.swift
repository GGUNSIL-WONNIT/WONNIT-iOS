//
//  SpaceCategory.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

enum SpaceCategory: String, Codable, CaseIterable {
    case smallTheater = "SMALL_THEATER"
    case makerSpace = "MAKER_SPACE"
    case musicPracticeRoom = "MUSIC_PRACTICE_ROOM"
    case danceStudio = "DANCE_STUDIO"
    case studyRoom = "STUDY_ROOM"
    
    static var allCases: [SpaceCategory] {
        [.smallTheater, .studyRoom, .makerSpace, .musicPracticeRoom, .danceStudio] // manually ordered
    }
    
    var label: String {
        switch self {
        case .smallTheater:
            return "소극장·전시"
        case .makerSpace:
            return "창작공방"
        case .musicPracticeRoom:
            return "음악연습실"
        case .danceStudio:
            return "댄스연습실"
        case .studyRoom:
            return "스터디룸"
        }
    }
    
    var iconName: String {
        switch self {
        case .smallTheater:
            return "spaceCategory/smallTheater"
        case .makerSpace:
            return "spaceCategory/makerSpace"
        case .musicPracticeRoom:
            return "spaceCategory/musicPracticeRoom"
        case .danceStudio:
            return "spaceCategory/danceStudio"
        case .studyRoom:
            return "spaceCategory/meetingRoom"
        }
    }
    
    init?(label: String) {
        guard let foundCase = Self.allCases.first(where: { $0.label == label }) else {
            return nil
        }
        self = foundCase
    }
}
