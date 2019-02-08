//
//  BaseService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum ResponseStatusCodes: Int {
    case successCode = 200
    case badRequest = 400
    case internalServerError = 500
    case networkConection = -1009
    case unknownCode = 0

    static func getStatusForCode(_ rawValue: Int) -> ResponseStatusCodes {
        switch rawValue {
        case 200: return .successCode
        case 400: return .badRequest
        case 500: return .internalServerError
        case -1009: return .networkConection
        default: return .unknownCode
        }
    }
}

enum ServiceError: Error {
    case badRequest
}

enum ParsingError: Error {
    case noExistingBody
}

typealias ParserMethod<Model> = (Data?) throws -> Model

class BaseService<Model: Codable> {

    func make(request: URLRequest,
              success: @escaping SuccessResponse<Model>,
              failure: @escaping ErrorResponse,
              parser: ParserMethod<Model>? = nil) {

        DebugManager.log(request)

        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { [weak self] (body, response, error) in
            guard let strongSelf = self, let urlResponse = response as? HTTPURLResponse else {
                failure(error ?? ServiceError.badRequest)
                return
            }
            let parserMethod = parser ?? strongSelf.genericParser
            strongSelf.processResponse(body: body, urlResponse: urlResponse, success: success, failure: failure, parser: parserMethod)
        }
        task.resume()
    }

    private func processResponse(body: Data?,
                                 urlResponse: HTTPURLResponse,
                                 success: @escaping SuccessResponse<Model>,
                                 failure: @escaping ErrorResponse,
                                 parser: @escaping ParserMethod<Model>) {

        DebugManager.log(urlResponse)

        switch ResponseStatusCodes.getStatusForCode(urlResponse.statusCode) {
        case .successCode:
            do {
                success(try parser(body))
            } catch let error {
                failure(error)
            }
        default:
            failure(ServiceError.badRequest)
        }
    }

    // MARK: Default Parser

    private var genericParser: ParserMethod<Model> = { body in
        guard let json = body else { throw ParsingError.noExistingBody }
        return try JSONDecoder().decode(Model.self, from: json)
    }
}
