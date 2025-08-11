//
//  FormToolbar.swift
//  WONNIT
//
//  Created by dohyeoplim on 8/11/25.
//

import UIKit

extension UIToolbar {
    static func makeFormToolbar(
        target: Any,
        done: Selector
    ) -> UIToolbar {
        let bar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        bar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "완료", style: .done, target: target, action: done)
        ]
        bar.sizeToFit()
        return bar
    }
}
