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

        guard let toViewController = transitionContext.viewController(forKey: .to) as? StationDetailViewController,
            let fromViewController = transitionContext.viewController(forKey: .from) as? MainViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }

        let containerView = toViewController.containerView
        toViewController.backButton.alpha = 0
        let finalScale = containerView.transform
        transitionContext.containerView.addSubview(toViewController.view)
        toViewController.view.backgroundColor = .clear
        containerView.transform = containerView.transform.translatedBy(x: 0, y: UIDevice.screenHeight)
        let finalFrameBack = toViewController.backButton.transform
        toViewController.backButton.transform = toViewController.backButton.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
            toViewController.backButton.transform = finalFrameBack
            toViewController.backButton.alpha = 1
            fromViewController.buttonsContiner.transform = fromViewController.buttonsContiner.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)
            fromViewController.buttonsContiner.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

class StationDetailTransitionOut: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Theme.Animation.defaultInterval
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? StationDetailViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? MainViewController else {
            transitionContext.cancelInteractiveTransition()
            return
        }

        let containerView = fromViewController.containerView
        let finalScale = containerView.transform.translatedBy(x: 0, y: UIDevice.screenHeight)
        let finalFrameBack = fromViewController.backButton.transform.translatedBy(x: 0, y: -Theme.Offset.extralarge)
        toViewController.setDefaultMap()

        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            containerView.transform = finalScale
            fromViewController.backButton.transform = finalFrameBack
            fromViewController.backButton.alpha = 0
            toViewController.buttonsContiner.transform = toViewController.buttonsContiner.transform.translatedBy(x: 0, y: Theme.Offset.extralarge)
            toViewController.buttonsContiner.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
