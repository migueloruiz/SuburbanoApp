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
        return Theme.Animation.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? StationDetailViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        let containerView = toViewController.containerView
        let finalScale = containerView.transform
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.backgroundColor = .clear
        containerView.transform = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
        }, completion:{ _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class StationDetailTransitionOut: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.Animation.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? StationDetailViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        let containerView = fromViewController.containerView
        let finalScale = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
        }, completion:{ _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}