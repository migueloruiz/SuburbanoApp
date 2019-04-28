//
//  RequestFactory.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delate = "DELETE"
}

enum RequestFactoryError: Error {
    case makeFailure
}

class RequestFactory {
    struct Constants {
        static let defaultTimeout: Double = 30
        static let defaulHeaders: [String: String] = ["Content-Type": "application/json"]
    }

    static func make(_ method: HTTPMethod,
                     headers: [String: String]? = nil,
                     endoint: Endpoint,
                     body: Data? = nil,
                     timeout: Double = Constants.defaultTimeout,
                     infoDictionary: [String: Any]? = Bundle.main.infoDictionary) throws -> URLRequest {

        let baseURL = try Environment.host(withType: endoint.host)
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
                throw RequestFactoryError.makeFailure
        }

        components.path = endoint.path
        if let params = endoint.params {
            components.queryItems = params.map { param, value in
                return URLQueryItem(name: param, value: value)
            }
        }

        var request = URLRequest(url: components.url ?? baseURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = getDefaultHeaders(customeHeaders: headers)
        request.timeoutInterval = timeout
        request.httpBody = body
        return request
    }

    static private func getDefaultHeaders(customeHeaders: [String: String]?) -> [String: String] {
        var headers = Constants.defaulHeaders
        guard let customeHeaders = customeHeaders else { return headers }
        for key in customeHeaders.keys { headers[key] = customeHeaders[key] }
        return headers
    }
}
