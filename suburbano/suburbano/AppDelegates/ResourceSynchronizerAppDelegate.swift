//
//  ResourceSynchronizerAppDelegate.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

final class ResourceSynchronizerAppDelegate: NSObject, UIApplicationDelegate {
    
    static let shared = ResourceSynchronizerAppDelegate()
    let service = ActivitiesUseCaseImpl(activitiesWebService: ActivitiesWebServiceImpl(), activitiesRepository: ActivitiesRepository())
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        syncResourse()
    }
}

extension ResourceSynchronizerAppDelegate {
    func syncResourse() {
        service.load()
    }
}
