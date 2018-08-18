//
//  MapViewFactory.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import Mapbox

protocol MapInitialConfiguration {
    var style: AppResource { get }
    var maxZoomLevel: Double { get }
    var minZoomLevel: Double { get }
    var mapBoundsNE: CLLocationCoordinate2D { get }
    var mapBoundsSW: CLLocationCoordinate2D { get }
}

class MapViewFactory {
    static func create(frame: CGRect, initilConfiguration: MapInitialConfiguration) -> MGLMapView {
        let styleURL = Utils.bundleUrl(forResource: initilConfiguration.style)
        let map = MGLMapView(frame: frame, styleURL: styleURL)
        map.maximumZoomLevel = initilConfiguration.maxZoomLevel
        map.minimumZoomLevel = initilConfiguration.minZoomLevel
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.attributionButton.isHidden = true
        return map
    }
}
