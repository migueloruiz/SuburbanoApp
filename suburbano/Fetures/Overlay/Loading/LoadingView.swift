//
//  LoadingView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 29/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Lottie

class LoadingView: UIView {

    private let animation: AnimationView
    private let dispatchGroup = DispatchGroup()
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    struct Constants {
        static let animationDuartion: TimeInterval = Theme.Animation.defaultInterval
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init(animation: String = AppConstants.Animations.trainLoader) {
        self.animation = AnimationView(name: animation)
        super.init(frame: .zero)
    }

    func configure() {
        alpha = 0
        animation.contentMode = .scaleAspectFit
        addSubViews([blurredEffectView, animation])
        blurredEffectView.fill()
        animation.fill()
    }

    func show(hiddingView: UIView? = nil) {
        guard !animation.isAnimationPlaying else { return }
        dispatchGroup.enter()
        animation.loopMode = .loop
        superview?.endEditing(true)
        superview?.bringSubviewToFront(self)

        UIView.animate(withDuration: Constants.animationDuartion, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.alpha = 1
            hiddingView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.animation.play(completion: { [weak self] _ in
                self?.dispatchGroup.leave()
            })
        })
    }

    func dismiss(hiddingView: UIView? = nil, completion: (() -> Void)? = nil ) {
        animation.loopMode = .playOnce
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.animation.pause()
            strongSelf.superview?.sendSubviewToBack(strongSelf)
            if let hiddingView = hiddingView {
                strongSelf.superview?.bringSubviewToFront(hiddingView)
            }

            UIView.animate(withDuration: Constants.animationDuartion, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.alpha = 0
                hiddingView?.alpha = 1
                }, completion: { _ in
                    strongSelf.animation.stop()
                    completion?()
            })
        })
    }
}
