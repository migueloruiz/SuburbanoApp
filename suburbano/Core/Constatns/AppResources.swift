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
}

struct AppResource {
    let fileName: String
    let extentionType: FileExtention
    var extention: String { return extentionType.rawValue }
}

struct AppResources {
    static let MapStyle = AppResource(fileName: "mapStyle", extentionType: .json)
    static let TrainRail = AppResource(fileName: "trainRail", extentionType: .json)
    static let Stations = AppResource(fileName: "stations", extentionType: .json)
    static let Prices = AppResource(fileName: "prices", extentionType: .json)
}
