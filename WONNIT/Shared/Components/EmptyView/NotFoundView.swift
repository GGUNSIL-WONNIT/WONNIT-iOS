//
//  NotFoundView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/5/25.
//

import SwiftUI

struct NotFoundView: View {
    let label: String
    
    init(label: String = "아직 추가된 공간이 없어요!") {
        self.label = label
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Image("icon/empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110, height: 110)
            
            Text(label)
                .body_02(.grey500)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NotFoundView()
}
