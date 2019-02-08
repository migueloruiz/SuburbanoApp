//
//  Endpoints.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum Host: String {
    case main = "MainHost"
    case fsuburbanos = "FsuburbanoHost"
    
    func getURL(infoDictionary: [String: Any]? = Bundle.main.infoDictionary) -> URL? {
        guard let envVariables = infoDictionary,
            let hosts = envVariables[AppConstants.App.BaseUrls] as? [String: String],
            let host = hosts[self.rawValue] else { return nil }
        return URL(string: host)
    }
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
