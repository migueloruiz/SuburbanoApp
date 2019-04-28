//
//  DirectionsApp.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol DirectionsApp {
    var host: String { get }
    var title: String { get }
    var disclaimer: String? { get }
    var icon: String { get }
    var shouldDisplay: Bool { get }
    func getLink(withStation station: Station) -> URL?
}

extension DirectionsApp {
    var isAppInstall: Bool {
        guard let url = URL(string: host) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}

struct Waze: DirectionsApp { // Base in https://developers.google.com/waze/deeplinks/
    var host: String { return "waze://" }
    var title: String { return "Llega con Waze" } // Localize
    var disclaimer: String? { return nil }
    var icon: String { return "wazeIcon" }
    var shouldDisplay: Bool { return isAppInstall }
    func getLink(withStation station: Station) -> URL? {
        let url = host + "?ll=\(station.accessLocation.latitude),\(station.accessLocation.longitude)&navigate=yes"
        return URL(string: url)
    }
}

struct GoogleMaps: DirectionsApp { // Base in https://developers.google.com/maps/documentation/urls/ios-urlscheme
    var host: String { return "comgooglemaps://" }
    var title: String { return "Llega con Google maps" } // Localize
    var disclaimer: String? { return nil }
    var icon: String { return "googleMapsIcon" }
    var shouldDisplay: Bool { return isAppInstall }
    func getLink(withStation station: Station) -> URL? {
        let url = host + "?saddr=Current+Location&daddr=\(station.accessLocation.latitude),\(station.accessLocation.longitude)&directionsmode=driving"
        return URL(string: url)
    }
}

struct AppleMaps: DirectionsApp { // Base in https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
    var host: String { return "http://maps.apple.com" }
    var title: String { return "Llega con Maps" } // Localize
    var disclaimer: String? { return nil }
    var icon: String { return "appleMapsIcon" }
    var shouldDisplay: Bool { return true }
    func getLink(withStation station: Station) -> URL? {
        let url = host + "/maps?daddr=\(station.accessLocation.latitude),\(station.accessLocation.longitude)"
        return URL(string: url)
    }
}

struct Uber: DirectionsApp { // Base in https://developer.uber.com/docs/riders/ride-requests/tutorials/deep-links/introduction
    var host: String { return "uber://" }
    var title: String {
        return isAppInstall ? "Llega en Uber" : "Llega en Uber con $50 de descuento*"
    }
    var disclaimer: String? {
        return isAppInstall ? nil : "* Descuento disponible solo para nuevos usuarios"
    }
    var icon: String { return "uberIcon" }
    var shouldDisplay: Bool { return true }
    func getLink(withStation station: Station) -> URL? {
        var url = ""
        if isAppInstall {
            url = "https://m.uber.com/ul/?client_id=h_bDvdJKViDKvvGAjs4aa-ssOL3737v6&action=setPickup&pickup=my_location&dropoff[latitude]=\(station.accessLocation.latitude)&dropoff[longitude]=\(station.accessLocation.longitude)&dropoff[nickname]=\(station.name)"
        } else {
            url = "https://www.uber.com/invite/qv5vdue"
        }
        return URL(string: url)
    }
}
