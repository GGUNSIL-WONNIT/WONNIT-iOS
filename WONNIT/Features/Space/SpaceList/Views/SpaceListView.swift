//
//  SpaceListView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct SpaceListView: View {
    @Environment(\.dismiss) private var dismiss
    
    let category: SpaceCategory?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("검색 결과 15개")
                    .body_04(.grey700)
                
                ForEach(0..<15) { _ in
                    SpacePreviewCardView(space: .placeholder, layout: .horizontal(height: 123), pricePosition: .trailing)
                }
                
//                NotFoundView()
//                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(category?.label ?? "최근 등록 장소")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.white)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundStyle(Color.grey900)
                    .font(.system(size: 18))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SpaceListView(category: .smallTheater)
    }
}
