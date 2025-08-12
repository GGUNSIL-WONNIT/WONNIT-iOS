//
//  UIVIew+Extension.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/12/25.
//

import Foundation
import UIKit

extension UIView {
    func snapshot(of rect: CGRect) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { ctx in
            self.drawHierarchy(in: CGRect(x: -rect.origin.x, y: -rect.origin.y, width: self.bounds.width, height: self.bounds.height), afterScreenUpdates: true)
        }
    }
}
