//
//  PopUpTransition.swift
//  suburbano
//
//  Created by Miguel Ruiz on 15/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class PopUpTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
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
        messageContiner.transform = messageContiner.transform.scaledBy(x: 0.1, y: 0.1)
        messageContiner.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            toViewController.view.backgroundColor = Theme.Pallete.darkBackground
            messageContiner.transform = finalScale
            messageContiner.alpha = 1
        }, completion:{ (complit) in
            transitionContext.completeTransition(true)
        })
    }
}
