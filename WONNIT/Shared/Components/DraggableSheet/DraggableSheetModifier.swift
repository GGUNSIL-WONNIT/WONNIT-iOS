//
//  DraggableSheetModifier.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import Foundation
import SwiftUI

struct DraggableContentSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selectedDetent: DraggableSheetDetent
    let sheetContent: () -> SheetContent

    @State private var showSheet = false
    @State private var dragOffset = UIScreen.main.bounds.height
    @State private var sheetId = UUID()

    private let springAnimation = Animation.spring(response: 0.4, dampingFraction: 0.8)

    func body(content: Content) -> some View {
        ZStack {
            content
            if showSheet {
                SheetView(
                    isPresented: $isPresented,
                    selectedDetent: $selectedDetent,
                    dragOffset: $dragOffset,
                    content: sheetContent
                ).id(sheetId)
            }
        }
        .onAppear { if isPresented { presentSheet() } }
        .onChange(of: isPresented) { _, newValue in
            newValue ? presentSheet() : dismissSheet()
        }
    }

    private func presentSheet() {
        sheetId = UUID()
        showSheet = true
        withAnimation(springAnimation) {
            dragOffset = selectedDetent.offset
        }
    }

    private func dismissSheet() {
        withAnimation(springAnimation) {
            dragOffset = UIScreen.main.bounds.height
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            showSheet = false
            selectedDetent = .medium
        }
    }
}
