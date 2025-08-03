//
//  ColumnsView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct ColumnsView: View {
    var body: some View {
        HomeSectionHeaderView(homeSection: .columns)
        
        CarouselView(itemSpacing: 16, leadingPadding: 16) {
            
        }
    }
}

#Preview {
    ColumnsView()
}
