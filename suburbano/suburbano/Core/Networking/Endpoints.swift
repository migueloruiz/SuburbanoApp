//
//  Endpoints.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

//"https://app.fsuburbanos.com/suburbano/mobileMethods/Saldo.php?tarjeta=2102802447&usr=subur"

enum Host: String {
    case main = "MainHost"
    case fsuburbanos = "FsuburbanosHost"
    
    func getURL() -> URL? {
        guard let envVariables = Bundle.main.infoDictionary,
            let hosts = envVariables[AppConstants.App.BaseUrls] as? [String : String],
            let host = hosts[self.rawValue] else { return nil }
        return URL(string: host)
    }
}

protocol Endpoint {
    var host: Host { get }
    var path: String { get }
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
    }
}