//
//  RecentlyAddedSpaceCardView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct RecentlyAddedSpaceCardView: View {
    let space: Space
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let imageURL = space.mainImageURL {
                
            }
        }
    }
}

#Preview {
    let demoSpace = Space.placeholder
    
    RecentlyAddedSpaceCardView(space: demoSpace)
}
