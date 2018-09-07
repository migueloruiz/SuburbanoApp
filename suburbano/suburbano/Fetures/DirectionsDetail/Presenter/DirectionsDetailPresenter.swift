//
//  DirectionsDetailPresenter.swift
//  suburbano
//
//  Created by Miguel Ruiz on 05/09/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

enum DirectionsApp: String {
    case waze
    case googleMaps
    case appleMaps
    case uber
    
    private var url: String {
        switch self {
        case .waze:
            return "waze://"
        case .googleMaps:
            return "comgooglemaps://"
        case .appleMaps:
            return "http://maps.apple.com"
        case .uber:
            return "uber://"
        }
    }
    
    var shouldDisplay: Bool {
        switch self {
        case .waze, .googleMaps:
            guard let url = URL(string: self.url) else { return false }
            return UIApplication.shared.canOpenURL(url)
        case .appleMaps, .uber: return true
        }
    }
    
    var title: String {
        switch self {
        case .waze:
            return "Llega con Waze" // Localize
        case .googleMaps:
            return "Llega con Google maps" // Localize
        case .appleMaps:
            return "Llega con Maps" // Localize
        case .uber:
            guard let url = URL(string: self.url),
                UIApplication.shared.canOpenURL(url) else {
                    return "Llega en Uber con $50 de descuento*" // Localize
            }
            return "Llega en Uber" // Localize
        }
    }
    
    var disclaimer: String? {
        switch self {
        case .uber:
            guard let url = URL(string: self.url),
                UIApplication.shared.canOpenURL(url) else { return "* Descuneto disponible para nuevos usuarios" }  // Localize
            return nil
        default: return nil
        }
    }
    
    var icon: UIImage {
        switch self {
        case .waze: return #imageLiteral(resourceName: "wazeIcon")
        case .googleMaps: return #imageLiteral(resourceName: "googleMapsIcon")
        case .appleMaps: return #imageLiteral(resourceName: "appleMapsIcon")
        case .uber: return #imageLiteral(resourceName: "uberIcon")
        }
    }
    
    static var allCases: [DirectionsApp] { return [.waze, .googleMaps, .appleMaps, .uber] }
}

protocol DirectionsDetailPresenter: class {
    var stationName: String { get }
    var disclaimers: [String] { get }
    var availableAppsRedirectios: [DirectionsApp] { get }
}

class DirectionsDetailPresenterImpl: DirectionsDetailPresenter {
    
    private let station: Station
    
    init(station: Station) {
        self.station = station
    }
    
    var stationName: String {
        return station.name
    }
    
    var availableAppsRedirectios: [DirectionsApp] {
        return DirectionsApp.allCases.filter { $0.shouldDisplay }
    }
    
    var disclaimers: [String] {
        return DirectionsApp.allCases.compactMap { $0.disclaimer }
    }
}
