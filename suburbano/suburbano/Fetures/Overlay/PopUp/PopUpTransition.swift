//
//  PopUpTransition.swift
//  suburbano
//
//  Created by Miguel Ruiz on 15/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class PopUpTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let notificationFeedback = UINotificationFeedbackGenerator()

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.Animation.defaultInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to) as? PopUpViewController else {
                transitionContext.cancelInteractiveTransition()
                return
        }

        let messageContiner = toViewController.messageContiner
        let finalScale = messageContiner.transform
        transitionContext.containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        toViewController.view.backgroundColor = .clear
        messageContiner.transform = messageContiner.transform.translatedBy(x: 0, y: UIDevice.screenHeight / 2)
        messageContiner.alpha = 0

        notificationFeedback.notificationOccurred(.warning)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: Theme.Animation.springWithDamping, initialSpringVelocity: Theme.Animation.springWithDamping, options: .curveEaseInOut, animations: {
            toViewController.view.backgroundColor = Theme.Pallete.darkBackground
            messageContiner.transform = finalScale
            messageContiner.alpha = 1
        }, completion: { (_) in
            transitionContext.completeTransition(true)
        })
    }
}
