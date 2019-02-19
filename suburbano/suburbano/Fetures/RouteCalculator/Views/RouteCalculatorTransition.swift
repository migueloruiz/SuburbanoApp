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
        return Theme.Animation.defaultInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toViewController = transitionContext.viewController(forKey: .to) as? RouteCalculatorViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? MainViewController else {
                transitionContext.cancelInteractiveTransition()
                return
        }

        transitionContext.containerView.addSubview(toViewController.view)

        let finalScalePickerContainer = toViewController.containerView.transform
        toViewController.containerView.transform = finalScalePickerContainer.translatedBy(x: 0, y: UIDevice.screenHeight)
        toViewController.containerView.alpha = 0
        let finalFrameBack = toViewController.backButton.transform
        toViewController.backButton.transform = toViewController.backButton.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            toViewController.backButton.transform = finalFrameBack
            toViewController.backButton.alpha = 1
            toViewController.containerView.transform = finalScalePickerContainer
            toViewController.containerView.alpha = 1
            fromViewController.buttonsContiner.transform = fromViewController.buttonsContiner.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)
            fromViewController.buttonsContiner.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class RouteCalculatorTransitionOut: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.Animation.defaultInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? RouteCalculatorViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? MainViewController else {
                transitionContext.cancelInteractiveTransition()
                return
        }

        toViewController.backFromDetailCamera()
        let finalFrameBack = fromViewController.backButton.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            fromViewController.backButton.transform = finalFrameBack
            fromViewController.backButton.alpha = 0
            fromViewController.containerView.transform = fromViewController.containerView.transform.translatedBy(x: 0, y: UIDevice.screenHeight)
            fromViewController.containerView.alpha = 0
            toViewController.buttonsContiner.transform = toViewController.buttonsContiner.transform.translatedBy(x: 0, y: Theme.Offset.extralarge)
            toViewController.buttonsContiner.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
