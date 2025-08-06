//
//  DraggableSheetView.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import Foundation
import SwiftUI

struct SheetView<Content: View>: View {
    @Binding var isPresented: Bool
    @Binding var selectedDetent: DraggableSheetDetent
    @Binding var dragOffset: CGFloat
    let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            SheetInternalView(
                isPresented: $isPresented,
                selectedDetent: $selectedDetent,
                dragOffset: $dragOffset,
                content: content
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .cornerRadius(selectedDetent == .large ? 0 : 20)
        .offset(y: dragOffset)
        .ignoresSafeArea(edges: selectedDetent == .large ? .all : [])
        .onChange(of: selectedDetent) { _, newDetent in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                dragOffset = newDetent.offset
            }
        }
    }
}

struct SheetInternalView<Content: View>: View {
    @Binding var isPresented: Bool
    @Binding var selectedDetent: DraggableSheetDetent
    @Binding var dragOffset: CGFloat
    let content: () -> Content

    @State private var gestureCoordinator = DraggableSheetGestureCoordinator()

    var body: some View {
        VStack(spacing: 0) {
            handleBar
            sheetScroll
        }
        .padding(.top, topPadding)
        .background(
            SheetGestureIntrospect { view in
                gestureCoordinator.attachToSheetView(view)
            }
        )
        .onAppear {
            gestureCoordinator.configure(
                dragOffset: $dragOffset,
                selectedDetent: $selectedDetent,
                isPresented: $isPresented
            )
        }
        .onDisappear { gestureCoordinator.cleanup() }
    }

    private var handleBar: some View {
        VStack {
            if selectedDetent == .large {
                HStack {
//                    Button(action: collapseToMiddle) {
//                        Image(systemName: "chevron.left.circle.fill")
//                            .font(.title)
//                    }
                    Button {
                        collapseToMiddle()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundStyle(Color.grey900)
                            .contentShape(Rectangle())
                    }
                    Spacer()
                }.padding(.horizontal)
            } else {
                Capsule().fill(Color.gray.opacity(0.5)).frame(width: 40, height: 5)
            }
        }
        .padding(.vertical, 8).frame(height: 44)
    }

    private var sheetScroll: some View {
        ScrollView {
            VStack(spacing: 0) { content() }
                .background(
                    ScrollViewIntrospect { scrollView in
                        gestureCoordinator.attachToScrollView(scrollView)
                    }
                )
        }
        .scrollDisabled(selectedDetent != .large)
    }

    private var topPadding: CGFloat {
        selectedDetent == .large ? DraggableSheetDetent.getSafeAreaTop() : 0
    }

    private func collapseToMiddle() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            selectedDetent = .medium
            dragOffset = selectedDetent.offset
        }
    }
}
