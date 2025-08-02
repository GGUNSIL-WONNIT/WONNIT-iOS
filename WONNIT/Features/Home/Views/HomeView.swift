//
//  HomeView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/1/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
//                    LogoView()
                    HeroView()
                    HomeMainContentsView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
