//
//  ExploreView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct ExploreView: View {
    @Environment(TabShouldResetManager.self) private var tabShouldResetManager
    @Bindable var mapViewModel: MapViewModel
    @State private var sheetDetent: DraggableSheetDetent = .small
    
    init(mapViewModel: MapViewModel = .init()) {
        self.mapViewModel = mapViewModel
    }
    
    var body: some View {
        ZStack {
            MapView(mapViewModel: mapViewModel)
        }
        .draggableContentSheet(
            isPresented: .constant(true),
            selectedDetent: $sheetDetent
        ) {
            if let space = mapViewModel.selectedSpace, sheetDetent != .small {
                SpaceDetailViewWithTransitions(space: space, detent: sheetDetent)
            } else {
                if sheetDetent == .small {
                    SpaceNearbyPeakView()
                        .padding()
                        .padding(.top, -16)
                } else {
                    SpaceNearbyView(mapViewModel: mapViewModel, detent: $sheetDetent)
                        .padding()
                }
            }
        }
        .onChange(of: mapViewModel.selection) { _, newSelection in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                if newSelection != nil {
                    sheetDetent = .medium
                } else {
                    sheetDetent = .small
                }
            }
        }
        .onChange(of: sheetDetent) { _, newDetent in
            if mapViewModel.selection == nil && newDetent == .medium {
                sheetDetent = .small
            }
        }
        .onChange(of: tabShouldResetManager.resetTriggers[.explore]) {
            handleTabReselect()
        }
    }
    
    private func handleTabReselect() {
//        guard let _ = mapViewModel.selection else { return }
        
        switch sheetDetent {
        case .large:
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                if let _ = mapViewModel.selection {
                    sheetDetent = .medium
                } else {
                    sheetDetent = .small
                }
            }

        case .medium:
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                if let _ = mapViewModel.selection {
                    mapViewModel.selection = nil
                    sheetDetent = .small
                } else {
                    sheetDetent = .small
                }
            }
            
        case .small:
            return
        }
    }
}
