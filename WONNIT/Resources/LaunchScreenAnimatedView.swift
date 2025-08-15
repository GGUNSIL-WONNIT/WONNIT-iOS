//
//  LaunchScreenAnimatedView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/16/25.
//

import SwiftUI
import Lottie

struct LaunchScreenAnimatedView: View {
    @State private var typedLogoVisible = false
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            Color.primaryPurple
            
            VStack {
                Spacer()
                Image("typedLogoWhite")
                    .opacity(typedLogoVisible ? 1 : 0)
                    .animation(.easeIn(duration: 0.2), value: typedLogoVisible)
            }
            .padding(.bottom, 64)
            
            LottieSymbolView(fileName: "wonnitSymbol", loopMode: .loop)
        }
        .ignoresSafeArea(.all, edges: .vertical)
        .onAppear {
            typedLogoVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isPresented = false
                }
            }
        }
    }
}

struct LottieSymbolView: UIViewRepresentable {
    let fileName: String
    let loopMode: LottieLoopMode
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let v = LottieAnimationView(name: fileName)
        v.loopMode = loopMode
        v.play()
        return v
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#Preview {
    LaunchScreenAnimatedView(isPresented: .constant(true))
}
