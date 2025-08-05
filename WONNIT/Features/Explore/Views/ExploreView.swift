//
//  ExploreView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/2/25.
//

import SwiftUI

struct ExploreView: View {
    @State var mapViewModel: MapViewModel
    @State private var sheetDetent: DraggableSheetDetent = .medium
    @Binding var shouldReset: Bool
    
    private var isSheetPresented: Binding<Bool> {
        Binding(
            get: {
                mapViewModel.selection != nil
            },
            set: { isShowing in
                if !isShowing {
                    mapViewModel.selection = nil
                }
            }
        )
    }
    
    init(mapViewModel: MapViewModel = .init(), shouldReset: Binding<Bool>) {
        self.mapViewModel = mapViewModel
        self._shouldReset = shouldReset
    }
    
    var body: some View {
        ZStack {
            MapView(mapViewModel: mapViewModel)
        }
        .draggableContentSheet(
            isPresented: isSheetPresented,
            selectedDetent: $sheetDetent
        ) {
            if let space = mapViewModel.selectedSpace {
                SpaceDetailViewWithTransitions(space: space, detent: sheetDetent)
            }
        }
        .onChange(of: shouldReset) {
            handleTabReselect()
        }
    }
    
    private func handleTabReselect() {
        guard let _ = mapViewModel.selection else { return }
        
        switch sheetDetent {
        case .large:
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                sheetDetent = .medium
            }

        case .medium:
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                mapViewModel.selection = nil
            }
//        default:
//            break
        }
    }
}
