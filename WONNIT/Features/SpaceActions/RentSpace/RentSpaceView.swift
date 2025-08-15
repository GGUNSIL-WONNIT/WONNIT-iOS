//
//  RentSpaceView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/15/25.
//

import SwiftUI

struct RentSpaceView: View {
    let spaceId: UUID
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    let sampleSpace = Space.placeholder
    
    RentSpaceView(spaceId: sampleSpace.id)
}
