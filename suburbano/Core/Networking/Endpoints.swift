//
//  Endpoints.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum Host: String {
    case main
    case fsuburbanos
}

protocol Endpoint {
    var host: Host { get }
    var path: String { get }
    var params: [String: String]? { get }
}

struct Endpoints {
    struct GeneralResource: Endpoint {
        let host: Host = .main
        let pathTemplate: String = "/migueloruiz/PersonalPage/gh-pages/api-dummy/subur/%@.%@"
        let resource: WebResource

        init(resource: WebResource) { self.resource = resource }

        var path: String {
            return String(format: pathTemplate, resource.fileName, resource.extention)
        }

        var params: [String: String]?
    }

    struct CardBalance: Endpoint {
        let host: Host = .fsuburbanos
        let cardId: String

        init(cardId: String) { self.cardId = cardId }

        var path: String { return "/suburbano/mobileMethods/Saldo.php" }

        var params: [String: String]? {
            return [ "usr": "subu",
                     "tarjeta": cardId ]
        }
    }
}
