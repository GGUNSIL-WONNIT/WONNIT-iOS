//
//  TagSelectorBridge.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import SwiftUI
import UIKit

struct TagSelectorBridge: UIViewRepresentable {
    let id: String
    let store: FormStateStore
    @Binding var tags: [String]
    var placeholder: String?
    
    func makeUIView(context: Context) -> TagSelectorView {
        let view = TagSelectorView()
        view.delegate = context.coordinator
        view.placeholder = placeholder
        view.font = .systemFont(ofSize: 16)
        view.tintColor = UIColor(Color.primaryPurple)
        view.inputAccessoryView = UIToolbar.makeFormToolbar(
            target: context.coordinator,
            done: #selector(Coordinator.handleDone)
        )
        view.accessibilityIdentifier = id
        context.coordinator.view = view
        return view
    }
    
    func updateUIView(_ uiView: TagSelectorView, context: Context) {
        if uiView.tags != tags {
            uiView.tags = tags
        }
        
        let shouldFocus = store.focusedID == id
        if shouldFocus, !uiView.isEditing {
            _ = uiView.becomeFirstResponder()
        }
        if !shouldFocus, uiView.isEditing {
            _ = uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, TagSelectorViewDelegate {
        private var parent: TagSelectorBridge
        weak var view: TagSelectorView?
        
        init(_ parent: TagSelectorBridge) {
            self.parent = parent
        }
        
        func tagsDidChange(to tags: [String]) {
            if parent.tags != tags {
                parent.tags = tags
            }
        }
        
        func didBeginEditing() {
            if parent.store.focusedID != parent.id {
                parent.store.focus(parent.id)
            }
        }
        
        func didEndEditing() {
            if parent.store.focusedID == parent.id {
                parent.store.blur()
            }
        }
        
        @objc func handleDone() {
            view?.finalizeEditing()
            _ = view?.resignFirstResponder()
        }
    }
}
