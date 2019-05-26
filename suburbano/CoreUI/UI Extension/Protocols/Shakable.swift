//
//  Shakable.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol Shakable {
    func shake()
}

extension Shakable where Self: UIView {
    func shake() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.4
        animation.values = [-20.0, 15.0, -10.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
        notificationFeedback.notificationOccurred(.error)
    }
}
