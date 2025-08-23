//
//  ImagePlaceholder.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct ImagePlaceholder: View {
    var width: CGFloat
    var height: CGFloat
    
    init(width: CGFloat = 158, height: CGFloat = 119) {
        self.width = width
        self.height = height
    }
    
    var body: some View {
        Color.gray.opacity(0.05)
            .frame(maxWidth: width, maxHeight: height)
            .overlay(
                Image(systemName: "photo")
                    .font(.system(size: 24))
                    .foregroundColor(.gray.opacity(0.5))
            )
    }
}

#Preview {
    ImagePlaceholder(width: 158, height: 119)
}
