//
//  SpaceDetailInformation.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import Foundation

struct SpaceDetailInformationItem: Identifiable, Hashable {
    let id: Space.DetailInformationType
    let iconName: String
    let content: String
}

extension Space {
    enum DetailInformationType: String, CaseIterable, CodingKey {
        case location
        case area
        case contact
        case openingHours
        case cautions
        case tags
    }
}

extension Space {
    var detailInformation: [SpaceDetailInformationItem] {
        var items: [SpaceDetailInformationItem] = []
        
        if let address = address?.address1 {
            items.append(.init(id: .location, iconName: "icon/location", content: address))
        }
        
        if let size = size {
            items.append(.init(id: .area, iconName: "icon/area", content: "\(size)㎡"))
        }
        
        if let contact = phoneNumber?.value {
            items.append(.init(id: .contact, iconName: "icon/phone", content: contact))
        }
        
        if let op = operationInfo {
            items.append(.init(id: .openingHours, iconName: "icon/clock", content: op.formattedOperationalInfo))
        }
        
        if let warnings = precautions {
            items.append(.init(id: .cautions, iconName: "icon/caution", content: warnings))
        }
        
        if let tags = spaceTags {
            items.append(.init(id: .tags, iconName: "icon/tag", content: tags.map { "#\($0)" }.joined(separator: " ")))
        }
        
        return items
    }
}
