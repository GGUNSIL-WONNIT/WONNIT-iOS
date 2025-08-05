//
//  DraggableSheetGestureCoordinator.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import Foundation
import SwiftUI

final class DraggableSheetGestureCoordinator: NSObject, UIGestureRecognizerDelegate {
    private weak var scrollView: UIScrollView?
    private weak var sheetGestureHostView: UIView?
    
    private var scrollPanGesture: UIPanGestureRecognizer?
    private var sheetPanGesture: UIPanGestureRecognizer?
    
    private var dragOffset: Binding<CGFloat>!
    private var selectedDetent: Binding<DraggableSheetDetent>!
    private var isPresented: Binding<Bool>!
    
    private var isDraggingSheet = false

    func configure(
        dragOffset: Binding<CGFloat>,
        selectedDetent: Binding<DraggableSheetDetent>,
        isPresented: Binding<Bool>
    ) {
        self.dragOffset = dragOffset
        self.selectedDetent = selectedDetent
        self.isPresented = isPresented
    }

    func attachToScrollView(_ scrollView: UIScrollView) {
        guard scrollPanGesture == nil else { return }
        self.scrollView = scrollView
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanFromScroll(_:)))
        gesture.delegate = self
        scrollView.addGestureRecognizer(gesture)
        scrollPanGesture = gesture
    }

    func attachToSheetView(_ view: UIView) {
        guard sheetPanGesture == nil else { return }
        self.sheetGestureHostView = view

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanFromSheet(_:)))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        sheetPanGesture = gesture
    }

    func cleanup() {
        if let gesture = scrollPanGesture {
            scrollView?.removeGestureRecognizer(gesture)
        }
        if let gesture = sheetPanGesture {
            sheetGestureHostView?.removeGestureRecognizer(gesture)
        }
        scrollPanGesture = nil
        sheetPanGesture = nil
    }

    @objc private func handlePanFromScroll(_ gesture: UIPanGestureRecognizer) {
        guard let scrollView, let dragOffset, let selectedDetent else { return }

        let translation = gesture.translation(in: scrollView.superview)
        let velocity = gesture.velocity(in: scrollView.superview)

        switch gesture.state {
        case .began:
            let atTop = scrollView.contentOffset.y <= 0
            let draggingDown = velocity.y > 0
            isDraggingSheet = selectedDetent.wrappedValue != .large || (atTop && draggingDown)
            scrollView.isScrollEnabled = !isDraggingSheet

        case .changed:
            if isDraggingSheet {
                dragOffset.wrappedValue = selectedDetent.wrappedValue.offset + translation.y
            }

        case .ended, .cancelled:
            scrollView.isScrollEnabled = true
            if isDraggingSheet {
                finalizeDrag(velocity: velocity)
            }
            isDraggingSheet = false

        default: break
        }
    }

    @objc private func handlePanFromSheet(_ gesture: UIPanGestureRecognizer) {
        guard let dragOffset, let selectedDetent, let hostView = sheetGestureHostView else { return }

        let translation = gesture.translation(in: hostView)
        let velocity = gesture.velocity(in: hostView)

        switch gesture.state {
        case .began:
            isDraggingSheet = true
            scrollView?.isScrollEnabled = false

        case .changed:
            dragOffset.wrappedValue = selectedDetent.wrappedValue.offset + translation.y

        case .ended, .cancelled:
            scrollView?.isScrollEnabled = true
            finalizeDrag(velocity: velocity)
            isDraggingSheet = false

        default: break
        }
    }

    private func finalizeDrag(velocity: CGPoint) {
        let predictedOffset = dragOffset.wrappedValue + velocity.y * 0.1
        let mediumY = DraggableSheetDetent.medium.offset
        let largeY = DraggableSheetDetent.large.offset
        let dismissY = UIScreen.main.bounds.height

        let toLargeThreshold = (mediumY + largeY) / 2
        let toDismissThreshold = (dismissY + mediumY) / 2

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if predictedOffset > toDismissThreshold {
                isPresented.wrappedValue = false
            } else if predictedOffset < toLargeThreshold {
                selectedDetent.wrappedValue = .large
            } else {
                selectedDetent.wrappedValue = .medium
            }

            dragOffset.wrappedValue = selectedDetent.wrappedValue.offset
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {
        true
    }
}
