//
//  AppResources.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum FileExtention: String {
    case json
    case geojson
    case bundle
}

enum AppBundle: String {
    case main
    case resilience = "Resilience"

    var identifier: String { return rawValue }
    var extention: String { return FileExtention.bundle.rawValue }
}

struct AppResource {
    let fileName: String
    let extentionType: FileExtention
    let bundle: AppBundle
    var extention: String { return extentionType.rawValue }
}

struct AppResources {
    static let MapStyle = AppResource(fileName: "mapStyle", extentionType: .json, bundle: .resilience)
    static let TrainRail = AppResource(fileName: "trainRail", extentionType: .json, bundle: .resilience)
    static let Stations = AppResource(fileName: "stations", extentionType: .json, bundle: .resilience)
    static let Prices = AppResource(fileName: "prices", extentionType: .json, bundle: .resilience)
    static let Schedule = AppResource(fileName: "schedule", extentionType: .json, bundle: .resilience)
}
