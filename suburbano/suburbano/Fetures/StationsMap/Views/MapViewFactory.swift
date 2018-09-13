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

struct StationsMap: MapInitialConfiguration {
    let style: AppResource = AppResources.Map.StyleFile
    let maxZoomLevel: Double = 20
    let minZoomLevel: Double = 8
    let mapBoundsNE: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.858455, longitude: -98.935441)
    let mapBoundsSW: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 19.191602, longitude: -99.421277)
}

class MapViewFactory {
    static func create(frame: CGRect, initilConfiguration: MapInitialConfiguration) -> MGLMapView {
        let styleURL = Utils.bundleUrl(forResource: initilConfiguration.style)
        let map = MGLMapView(frame: frame, styleURL: styleURL)
        map.maximumZoomLevel = initilConfiguration.maxZoomLevel
        map.minimumZoomLevel = initilConfiguration.minZoomLevel
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.attributionButton.isHidden = true
        map.logoView.isHidden = true
        map.compassView.isHidden = true
        return map
    }
}
