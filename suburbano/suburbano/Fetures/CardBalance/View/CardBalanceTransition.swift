//
//  CardBalanceTransition.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class CardBalanceTransitionIn: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? CardBalanceViewController else {
                transitionContext.cancelInteractiveTransition()
                return
        }
        
        let containerView = toViewController.containerView
        let finalScale = containerView.transform
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.backgroundColor = .clear
        containerView.transform = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.backgroundColor = Theme.Pallete.darkBackground
            containerView.transform = finalScale
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class CardBalanceTransitionOut: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? CardBalanceViewController else {
                transitionContext.cancelInteractiveTransition()
                return
        }
        
        let containerView = fromViewController.containerView
        let finalScale = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
        transitionContext.containerView.backgroundColor = .clear
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.view.backgroundColor = .clear
            containerView.transform = finalScale
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
