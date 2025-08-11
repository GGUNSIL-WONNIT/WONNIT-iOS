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
        prev: Selector,
        next: Selector,
        done: Selector
    ) -> UIToolbar {
        let bar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        bar.items = [
            UIBarButtonItem(title: "이전", style: .plain, target: target, action: prev),
            UIBarButtonItem(title: "다음", style: .plain, target: target, action: next),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "완료", style: .done, target: target, action: done)
        ]
        bar.sizeToFit()
        return bar
    }
}
