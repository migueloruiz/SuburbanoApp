//
//  DirectionsAppsFactory.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class DirectionsAppsFactory {
    static func getAvailableApps() -> (apps: [DirectionsApp], disclaimer: String?) {
        let allApps: [DirectionsApp] = [Waze(), GoogleMaps(), AppleMaps(), Uber()]
        let available = allApps.filter { $0.shouldDisplay }
        let discailmers = allApps.compactMap { $0.disclaimer }
        return (available, discailmers.first)
    }
}
