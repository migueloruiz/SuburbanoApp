//
//  StationDetailTransition.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class StationDetailTransitionIn: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? StationDetailViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        let containerView = toViewController.containerView
        let backButton = toViewController.backButton
        backButton.alpha = 0
        let finalScale = containerView.transform
        let finalFrameBack = backButton.transform
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.backgroundColor = .clear
        containerView.transform = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
        backButton.transform = backButton.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
            backButton.transform = finalFrameBack
            backButton.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class StationDetailTransitionOut: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? StationDetailViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        let containerView = fromViewController.containerView
        let backButton = fromViewController.backButton
        let finalScale = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
        let finalFrameBack = backButton.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
            backButton.transform = finalFrameBack
            backButton.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
