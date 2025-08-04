//
//  DraggableSheetGestureCoordinator.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import Foundation
import SwiftUI

class DraggableSheetGestureCoordinator: NSObject, UIGestureRecognizerDelegate {
    private weak var scrollView: UIScrollView?
    private var panGesture: UIPanGestureRecognizer?
    private var isDraggingSheet = false
    
    private var bindDragOffset: Binding<CGFloat>!
    private var bindSelectedDetent: Binding<DraggableSheetDetent>!
    private var bindIsPresented: Binding<Bool>!

    func configure(
        scrollView: UIScrollView,
        dragOffset: Binding<CGFloat>,
        selectedDetent: Binding<DraggableSheetDetent>,
        isPresented: Binding<Bool>
    ) {
        self.scrollView = scrollView
        self.bindDragOffset = dragOffset
        self.bindSelectedDetent = selectedDetent
        self.bindIsPresented = isPresented
        
        guard panGesture == nil else { return }
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gesture.delegate = self
        scrollView.addGestureRecognizer(gesture)
        panGesture = gesture
    }

    func cleanup() {
        if let gesture = panGesture { scrollView?.removeGestureRecognizer(gesture); panGesture = nil }
    }

    func gestureRecognizer(_ g: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith o: UIGestureRecognizer) -> Bool { true }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let scrollView = scrollView else { return }
        let translation = gesture.translation(in: scrollView.superview)
        
        switch gesture.state {
        case .began:
            let atTop = scrollView.contentOffset.y <= 0
            let isDraggingDown = gesture.velocity(in: scrollView).y > 0
            isDraggingSheet = (bindSelectedDetent.wrappedValue != .large) || (atTop && isDraggingDown)
            scrollView.isScrollEnabled = !isDraggingSheet

        case .changed:
            if isDraggingSheet {
                bindDragOffset.wrappedValue = bindSelectedDetent.wrappedValue.offset + translation.y
            }

        case .ended, .cancelled:
            scrollView.isScrollEnabled = true
            if isDraggingSheet { decideFinalPosition(velocity: gesture.velocity(in: scrollView.superview)) }
            isDraggingSheet = false

        default: break
        }
    }

    private func decideFinalPosition(velocity: CGPoint) {
        let finalPosition = bindDragOffset.wrappedValue + velocity.y * 0.1
        let boundaryHigh = (DraggableSheetDetent.medium.offset + DraggableSheetDetent.large.offset) / 2
        let boundaryLow = (UIScreen.main.bounds.height + DraggableSheetDetent.medium.offset) / 2

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if finalPosition > boundaryLow {
                bindIsPresented.wrappedValue = false
            } else if finalPosition < boundaryHigh {
                bindSelectedDetent.wrappedValue = .large
                scrollView?.setContentOffset(.zero, animated: true)
            } else {
                bindSelectedDetent.wrappedValue = .medium
            }
            bindDragOffset.wrappedValue = bindSelectedDetent.wrappedValue.offset
        }
    }
}
