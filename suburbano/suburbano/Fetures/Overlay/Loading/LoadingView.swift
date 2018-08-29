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
    
    private let animation = LOTAnimationView(name: "loading")
    private let dispatchGroup = DispatchGroup()
    private let blurredEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    struct Constants {
        static let animationDuartion: TimeInterval = 0.5 // TODO
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init() { super.init(frame: .zero) }
    
    func configure() {
        alpha = 0
        animation.contentMode = .scaleAspectFit
        addSubview(animation)
        addSubViews([blurredEffectView, animation])
        blurredEffectView.fillSuperview()
        animation.fillSuperview()
    }
    
    func show(hiddingView: UIView? = nil) {
        animation.loopAnimation = true
        superview?.endEditing(true)
        superview?.bringSubview(toFront: self)
        
        dispatchGroup.enter()
        UIView.animate(withDuration: Constants.animationDuartion, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.alpha = 1
            hiddingView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.animation.play(completion: { [weak self] _ in
                self?.dispatchGroup.leave()
            })
        })
    }
    
    func dismiss(hiddingView: UIView? = nil, completion: (()->Void)? = nil ) {
        animation.loopAnimation = false
        dispatchGroup.notify(queue: .main, execute: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.animation.stop()
            strongSelf.superview?.sendSubview(toBack: strongSelf)
            
            UIView.animate(withDuration: Constants.animationDuartion, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.alpha = 0
                hiddingView?.alpha = 1
                }, completion: { _ in
                    completion?()
            })
        })
    }
}