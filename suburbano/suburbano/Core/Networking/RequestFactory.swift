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

enum RequestFactoryError: Error {
    case makeFailure
}

class RequestFactory {
    struct Constants {
        static let defaultTimeout: Double = 30
    }
    
    static func make(_ method: HTTPMethod, endoint: Endpoint, timeout: Double = Constants.defaultTimeout) throws -> URLRequest {
        guard let baseURL = endoint.host.getURL(),
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
                throw RequestFactoryError.makeFailure
        }
        
        components.path = endoint.path
        components.queryItems = endoint.params.map { param, value in
            return URLQueryItem(name: param, value: value)
        }
        var request = URLRequest(url: components.url ?? baseURL)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeout
        return request
    }
}
