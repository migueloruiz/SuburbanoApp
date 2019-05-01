//
//  WebResources.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

struct WebResource {
    let fileName: String
    let extentionType: FileExtention
    var extention: String { return extentionType.rawValue }
}

struct WebResources {
    static let Alerts = WebResource(fileName: "alerts", extentionType: .json)
    static let General = WebResource(fileName: "general", extentionType: .json)
    static let Update = WebResource(fileName: "resurcesUpdate", extentionType: .json)
    static let Prices = WebResource(fileName: "prices", extentionType: .json)
    static let WaitTime = WebResource(fileName: "waitTime", extentionType: .json)
}