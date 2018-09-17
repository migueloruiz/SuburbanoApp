//
//  ApplicationCoordinatorAppDelegate.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

final class ApplicationCoordinatorAppDelegate: NSObject, UIApplicationDelegate {
    
    static let shared = ApplicationCoordinatorAppDelegate()
    private var applicationCoordinator: ApplicationCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        AppDelegate.shared?.window = window
        self.applicationCoordinator = ApplicationCoordinator(window: window)
        applicationCoordinator?.start()
        return true
    }
}
