//
//  DesignSystemDemoView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/3/25.
//

import SwiftUI

struct DesignSystemDemoView: View {
    var body: some View {
        NavigationStack {
            HStack(alignment: .top, spacing: 60) {
                VStack( spacing: 16) {
                    Text("Text Styles")
                        .head_01()
                        .foregroundColor(.grey900)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("title-01")
                            .title_01()
                            .foregroundColor(.grey900)
                        Text("title-02")
                            .title_02()
                            .foregroundColor(.grey900)
                        
                        Text("head-01")
                            .head_01()
                            .foregroundColor(.grey900)
                        
                        Text("head-02")
                            .head_02()
                            .foregroundColor(.grey900)
                        
                        Text("body-01")
                            .body_01()
                            .foregroundColor(.grey900)
                        
                        Text("body-02")
                            .body_02()
                            .foregroundColor(.grey900)
                        
                        Text("body-03")
                            .body_03()
                            .foregroundColor(.grey900)
                        
                        Text("body-04")
                            .body_04()
                            .foregroundColor(.grey900)
                        
                        Text("body-05")
                            .body_05()
                            .foregroundColor(.grey900)
                        
                        Text("body-06")
                            .body_06()
                            .foregroundColor(.grey900)
                        
                        Text("caption-01")
                            .caption_01()
                            .foregroundColor(.grey900)
                        
                        Text("caption-02")
                            .caption_02()
                            .foregroundColor(.grey900)
                        
                        Text("caption-03")
                            .caption_03()
                            .foregroundColor(.grey900)
                    }
                }
                
                VStack(spacing: 16) {
                    Text("Colors")
                        .head_01()
                        .foregroundColor(.grey900)
                    
                    VStack(spacing: 10) {
                        ForEach([Color.primaryPurple, .primaryPurple300, .grey900, .grey700, .grey500, .grey300, .grey200, .grey100], id: \.self) { color in
                            Rectangle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .navigationTitle("Design Systems")
        }
    }
    
}

#Preview {
    DesignSystemDemoView()
}
