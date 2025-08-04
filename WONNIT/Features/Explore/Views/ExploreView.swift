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
                if let name = space.name {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(name)
                    }
                }
            }
        }

    }
}

#Preview {
    ExploreView()
}
