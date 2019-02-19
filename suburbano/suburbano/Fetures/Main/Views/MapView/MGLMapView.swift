//
//  MGLMapView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/18/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Mapbox

extension MGLMapView {
    func set(camera: MGLMapCamera,
             withDuration duartion: TimeInterval = Theme.Animation.defaultInterval,
             animationTiming: CAMediaTimingFunctionName = .easeIn) {
        setCamera(camera,
                  withDuration: duartion,
                  animationTimingFunction: CAMediaTimingFunction(name: animationTiming))
    }

    func set(camera: MGLMapCamera,
             withDuration duartion: TimeInterval = Theme.Animation.defaultInterval,
             animationTiming: CAMediaTimingFunctionName = .easeIn,
             completion: (() -> Void)? ) {
        setCamera(camera,
                  withDuration: duartion,
                  animationTimingFunction: CAMediaTimingFunction(name: animationTiming), completionHandler: completion)
    }
}
