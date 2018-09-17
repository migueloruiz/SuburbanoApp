//
//  RouteCalculatorTransition.swift
//  suburbano
//
//  Created by Miguel Ruiz on 13/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class RouteCalculatorTransitionIn: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? RouteCalculatorViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? MainNavigationViewController,
            let selectedViewCpntroller = fromViewController.selectedViewController() as? MapStationsViewController else {
                transitionContext.cancelInteractiveTransition()
                return
        }
        
        transitionContext.containerView.addSubview(toViewController.view)
        
        let finalScalePickerContainer = toViewController.containerView.transform
        toViewController.containerView.transform = finalScalePickerContainer.translatedBy(x: 0, y: Utils.screenHeight)
        toViewController.containerView.alpha = 0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            toViewController.containerView.transform = finalScalePickerContainer
            toViewController.containerView.alpha = 1
            selectedViewCpntroller.buttonsContiner.transform = selectedViewCpntroller.buttonsContiner.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)
            selectedViewCpntroller.buttonsContiner.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class RouteCalculatorTransitionOut: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.AnimationInterval.defaultInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? RouteCalculatorViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? MainNavigationViewController,
            let selectedViewCpntroller = toViewController.selectedViewController() as? MapStationsViewController else {
                transitionContext.cancelInteractiveTransition()
                return
        }
        
        selectedViewCpntroller.backFromDetailCamera()

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.containerView.transform = fromViewController.containerView.transform.translatedBy(x: 0, y: Utils.screenHeight)
            fromViewController.containerView.alpha = 0
            selectedViewCpntroller.buttonsContiner.transform = selectedViewCpntroller.buttonsContiner.transform.translatedBy(x: 0, y: Theme.Offset.extralarge)
            selectedViewCpntroller.buttonsContiner.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
