//
//  PluggableApplicationDelegate.swift
//  PluggableApplicationDelegate
//
//  Created by Fernando Ortiz on 2/24/17.
//  Copyright © 2017 Fernando Martín Ortiz. All rights reserved.
//

import UIKit

open class PluggableApplicationDelegate: UIResponder, UIApplicationDelegate {
    
    public var window: UIWindow?
    
    open var services: [UIApplicationDelegate] { return [] }
    private lazy var __services: [UIApplicationDelegate] = { return self.services }()
    
    open func applicationDidFinishLaunching(_ application: UIApplication) {
        __services.forEach { $0.applicationDidFinishLaunching?(application) }
    }
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let result = __services.map { $0.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true }
        return !result.contains(false)
    }
    
    open func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let result = __services.map { $0.application?(application, willFinishLaunchingWithOptions: launchOptions) ?? true }
        return !result.contains(false)
    }
    
    open func applicationDidBecomeActive(_ application: UIApplication) {
        __services.forEach { $0.applicationDidBecomeActive?(application)}
    }
    
    open func applicationWillResignActive(_ application: UIApplication) {
        __services.forEach { $0.applicationWillResignActive?(application)}
    }
    
    open func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
         __services.forEach { $0.applicationShouldRequestHealthAuthorization?(application)}
    }
    
    open func applicationDidEnterBackground(_ application: UIApplication) {
        __services.forEach { $0.applicationDidEnterBackground?(application)}
    }
    
    open func applicationWillEnterForeground(_ application: UIApplication) {
        __services.forEach { $0.applicationWillEnterForeground?(application)}
    }
    
    open func applicationWillTerminate(_ application: UIApplication) {
        __services.forEach { $0.applicationWillTerminate?(application)}
    }
    
    open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        __services.forEach { $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)}
    }
}
