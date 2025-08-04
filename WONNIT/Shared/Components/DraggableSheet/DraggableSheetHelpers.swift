//
//  DraggableSheetHelpers.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/4/25.
//

import Foundation
import SwiftUI

struct ScrollViewIntrospect: UIViewRepresentable {
    let onFind: (UIScrollView) -> Void

    func makeUIView(context: Context) -> UIView { UIView() }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let scrollView = findScrollView(in: uiView) else { return }
            onFind(scrollView)
        }
    }

    private func findScrollView(in view: UIView?) -> UIScrollView? {
        var current = view
        while let v = current {
            if let scroll = v as? UIScrollView { return scroll }
            current = v.superview
        }
        return nil
    }
}

extension DraggableSheetDetent {
    var offset: CGFloat {
        switch self {
        case .medium: return UIScreen.main.bounds.height - 360
        case .large: return 0
        }
    }
    
    static func getSafeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0
    }
}
