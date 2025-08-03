//
//  SpaceListView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct SpaceListView: View {
    let category: SpaceCategory?
    
    var body: some View {
        ScrollView {
            VStack {
                Text("얍")
            }
        }
        .navigationTitle(category?.label ?? "최근 등록 장소")
    }
}

#Preview {
    SpaceListView(category: .makerSpace)
}
