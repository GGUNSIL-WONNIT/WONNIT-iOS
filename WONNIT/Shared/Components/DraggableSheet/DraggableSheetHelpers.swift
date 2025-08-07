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

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let scrollView = view.findSuperview(of: UIScrollView.self) {
                onFind(scrollView)
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct SheetGestureIntrospect: UIViewRepresentable {
    let onViewReady: (UIView) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            if let hostView = view.superview {
                onViewReady(hostView)
            }
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

extension DraggableSheetDetent {
    var offset: CGFloat {
        switch self {
        case .small: return UIScreen.main.bounds.height - 280
        case .medium: return UIScreen.main.bounds.height - 350
        case .large: return 0
        }
    }
    
    static func getSafeAreaTop() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0
    }
}

extension UIView {
    func findSuperview<T: UIView>(of type: T.Type) -> T? {
        var current: UIView? = self
        while let view = current {
            if let match = view as? T {
                return match
            }
            current = view.superview
        }
        return nil
    }
}
