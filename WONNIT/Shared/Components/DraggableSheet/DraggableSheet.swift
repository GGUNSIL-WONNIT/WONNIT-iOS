//
//  DraggableSheet.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import Foundation
import SwiftUI

public enum DraggableSheetDetent: CaseIterable {
    case medium, large
}

public extension View {
    func draggableContentSheet<Content: View>(
        isPresented: Binding<Bool>,
        selectedDetent: Binding<DraggableSheetDetent>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(DraggableContentSheet(isPresented: isPresented, selectedDetent: selectedDetent, sheetContent: content))
    }
}
