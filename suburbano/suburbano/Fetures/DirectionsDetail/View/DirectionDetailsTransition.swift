//
//  DirectionDetailsTransition.swift
//  suburbano
//
//  Created by Miguel Angel Ruiz Galvez on 9/7/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class DirectionDetailsTransitionIn: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? DirectionsDetailViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        let containerView = toViewController.containerView
        let title = toViewController.titleLabel
        let finalScale = containerView.transform
        let titlefinalScale = title.transform
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.backgroundColor = .clear
        containerView.transform = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
        
        title.transform = title.transform.translatedBy(x: 0, y: -200)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
            toViewController.view.backgroundColor = Theme.Pallete.darkBackground
            title.transform = titlefinalScale
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class DirectionDetailsTransitionOut: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? DirectionsDetailViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }
        
        let containerView = fromViewController.containerView
        let title = fromViewController.titleLabel
        let finalScale = containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
        let titlefinalScale = title.transform.translatedBy(x: 0, y: -200)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
            fromViewController.view.backgroundColor = .clear
            title.transform = titlefinalScale
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
