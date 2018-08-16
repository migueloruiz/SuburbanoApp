//
//  RequestFactory.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delate = "DELATE"
}

class RequestFactory {
    struct Constants {
        static let defaultTimeout: Double = 30
    }
    
    static func make(_ method: HTTPMethod, host: Host = .main, endoint: Endpoint, timeout: Double = Constants.defaultTimeout) -> URLRequest? {
        guard let baseURL = host.getURL(),
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else { return nil }
        
        components.path = endoint.path
        var request = URLRequest(url: components.url ?? baseURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        return request
    }
}

