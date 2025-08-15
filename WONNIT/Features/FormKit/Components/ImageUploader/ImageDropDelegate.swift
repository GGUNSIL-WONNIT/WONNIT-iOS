//
//  ImageDropDelegate.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/14/25.
//

import Foundation
import SwiftUI

struct ImageDropDelegate: DropDelegate {
    let item: UIImage
    @Binding var items: [UIImage]
    @Binding var draggedItem: UIImage?
    
    func performDrop(info: DropInfo) -> Bool {
        guard let draggedItem = self.draggedItem,
              let fromIndex = items.firstIndex(of: draggedItem),
              let toIndex = items.firstIndex(of: item)
        else {
            return false
        }
        
        withAnimation(.spring()) {
            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
        
        self.draggedItem = nil
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}
