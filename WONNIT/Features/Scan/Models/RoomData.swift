//
//  RoomData.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import Foundation
import UIKit

struct RoomData: Identifiable, Codable, Equatable {
    public var id = UUID()
    let roomURL: URL
    let thumbnailData: Data
    
    static func == (lhs: RoomData, rhs: RoomData) -> Bool {
        lhs.id == rhs.id
    }

    public var thumbnail: UIImage? {
        return UIImage(data: thumbnailData)
    }

    public init(roomURL: URL, thumbnail: UIImage) {
        self.roomURL = roomURL
        self.thumbnailData = thumbnail.pngData() ?? Data()
    }
}
