//
//  ColumnsView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct ColumnsView: View {
    var body: some View {
        VStack(spacing: 16) {
            HomeSectionHeaderView(homeSection: .columns)
            
            CarouselView(itemSpacing: 16, leadingPadding: 16) {
                ForEach(1..<5) { _ in
                    ColumnCardView(column: .placeholder)
                }
            }
        }
    }
}

#Preview {
    ColumnsView()
}
