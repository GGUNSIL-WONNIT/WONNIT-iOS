//
//  SpaceNearbyPeakView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/23/25.
//

import SwiftUI

struct SpaceNearbyPeakView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("가까운 공간")
                .title_01(.grey900)
            
            Text("내 주변에 등록된 공간을 확인해보세요.")
                .body_04(.grey700)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
