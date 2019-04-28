//
//  AppDelegate.swift
//  suburbano
//
//  Created by Miguel Ruiz on 06/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {

    static var shared: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    override var services: [UIApplicationDelegate] {
        return [
            RealmAppDelegate.shared,
            FireBaseAppDelegate.shared,
            ApplicationCoordinatorAppDelegate.shared,
            ResourceSynchronizerAppDelegate.shared
        ]
    }
}
