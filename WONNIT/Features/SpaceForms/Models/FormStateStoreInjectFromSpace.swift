//
//  FormStateStoreInjectFromSpace.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/7/25.
//

import Foundation

extension FormStateStore {
    func inject(from space: Space) {
        values["mainImage"] = .some(.none)
        values["subImages"] = .some(.none)
        
        values["address1"] = .string(space.address?.address1 ?? "")
        values["address2"] = .string(space.address?.address2 ?? "")
        values["name"] = .string(space.name ?? "")
        
        if let category = space.category {
            values["category"] = .string(category.label)
        }
        
        if let size = space.size {
            values["area"] = .double(size)
        }
        
        if let tags = space.spaceTags {
            values["tags"] = try? .codable(JSONEncoder().encode(tags))
        }
        
        if let op = space.operationInfo {
            values["openDay"] = .codable(try! JSONEncoder().encode(op.dayOfWeeks))
            values["openTime"] = .codable(try! JSONEncoder().encode(TimeRange(startAt: op.startAt, endAt: op.endAt)))
        }
        
        if let amount = space.amountInfo {
            values["pricing"] = .codable(try! JSONEncoder().encode(amount))
        }
        
        if let phone = space.phoneNumber?.value {
            values["contact"] = .string(phone)
        }
        
        values["cautions"] = .string(space.precautions ?? "")
        
        // TODO: room scan
    }
}
