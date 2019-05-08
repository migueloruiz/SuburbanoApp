//
//  FireBaseAppDelegate.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit
import Firebase

final class FireBaseAppDelegate: NSObject, UIApplicationDelegate {

    static let shared = FireBaseAppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        configureAnalytics()
        return true
    }
}

extension FireBaseAppDelegate {
    private func configureAnalytics() {
        Analytics.setAnalyticsCollectionEnabled(true)
    }
}
