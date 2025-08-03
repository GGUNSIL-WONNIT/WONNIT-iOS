//
//  ImagePlaceholder.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct ImagePlaceholder: View {
    let (width, height) : (CGFloat, CGFloat)
    
    var body: some View {
        Color.gray.opacity(0.05)
            .frame(width: width, height: height)
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
