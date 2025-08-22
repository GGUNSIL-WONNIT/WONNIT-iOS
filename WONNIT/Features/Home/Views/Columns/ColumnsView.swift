//
//  ColumnsView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct ColumnsView: View {
    private let columns = Column.defaultList
    
    var body: some View {
        VStack(spacing: 16) {
            HomeSectionHeaderView(homeSection: .columns)
            
            CarouselView(itemSpacing: 16, leadingPadding: 16) {
                ForEach(columns, id: \.id) { column in
                    ColumnCardView(column: column)
                }
            }
        }
    }
}

#Preview {
    ColumnsView()
}
