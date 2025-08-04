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

    
    init(mapViewModel: MapViewModel = .init()) {
        self.mapViewModel = mapViewModel
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

    }
}

#Preview {
    ExploreView()
}
