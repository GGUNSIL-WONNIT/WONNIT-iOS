//
//  DonePageView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/6/25.
//

import SwiftUI

struct DonePageView: View {
    @State private var showConfetti = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .frame(width: 96, height: 96)
                    .foregroundColor(.primaryPurple)
                    .symbolEffect(.bounce.down.byLayer, options: .nonRepeating)
                
                
                Text("새로운 공간이\n등록되었습니다!")
                    .head_02(.grey900)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            
            ConfettiView(isEmitting: $showConfetti)
        }
        .onAppear {
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showConfetti = false
            }
        }
    }
}

#Preview {
    DonePageView()
}
