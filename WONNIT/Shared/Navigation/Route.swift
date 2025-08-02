//
//  Route.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import Foundation

enum Route: Hashable {
    case spaceListByCategory(_ category: SpaceCategory)
    case spaceListByRecent
    case fullScreenModal(ModalRoute)
    
    enum ModalRoute: Hashable {
        //
    }
}
