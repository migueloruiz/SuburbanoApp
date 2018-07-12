//
//  BaseService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

public enum ServiceResponse<Model> {
    case success(response: [Model], headers: [String: String])
    case failure(error: ErrorResponse)
    case notConnectedToInternet
}

public enum ResponseStatusCodes: Int {
    case successCode = 200
    case badRequest = 400
    case internalServerError = 500
    case timeOutCode = -1001
    case couldnotConnectCode = -1004
    case networkConnectionLost = -1005
    case noInternetConnection = -500
    case jsonParsing = -2000
    case nilRequest = -5000
    case unknownCode = 0
    
    static func getStatusForCode(_ rawValue: Int) -> ResponseStatusCodes {
        switch rawValue {
        case 200: return .successCode
        case 400: return .badRequest
        case 500: return .internalServerError
        case -1001: return .timeOutCode
        case -1004: return .couldnotConnectCode
        case -1005: return .networkConnectionLost
        case -500: return .noInternetConnection
        case -2000: return .jsonParsing
        case -5000: return .jsonParsing
        default: return .unknownCode
        }
    }
}

public struct ErrorResponse {
    internal var code = ResponseStatusCodes.unknownCode
    internal var header = ""
    internal var body = ""
    internal var tecnicalDescription = ""
    
    static func generalError(code: ResponseStatusCodes = ResponseStatusCodes.unknownCode, tecnicalDescription: String = "") -> ErrorResponse {
        
        return ErrorResponse(code: code,
                             header: "ERRORS_GENERAL_ERROR_HEADER",
                             body: "ERRORS_GENERAL_ERROR_BODY",
                             tecnicalDescription: tecnicalDescription)
    }
}

public enum Response<Model> {
    case success(objects: [Model])
    case failure
    case notConnectedToInternet
}

// TODO: Add targetVariable to print requests

open class BaseService<Model: Codable> {
    
    func make(request: URLRequest, completion: @escaping (ServiceResponse<Model>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request) { [weak self] (body, response, error) in
                guard let strongSelf = self else { return }
                guard let urlResponse = response as? HTTPURLResponse else {
                    strongSelf.handle(error: error, completion: completion)
                    return
                }
//                print(body!)
//                print(urlResponse)
                strongSelf.processResponse(json: body, urlResponse: urlResponse, completion: completion)
            }
            task.resume()
        }
    }
    
    private func processResponse(json: Data?,
                                 urlResponse: HTTPURLResponse,
                                 completion: @escaping (ServiceResponse<Model>) -> Void) {
        
        guard let jsonResponse = json else {
            handleFailure(code: ResponseStatusCodes.unknownCode.rawValue, message: "", completion: completion)
            return
        }
        
        switch urlResponse.statusCode {
        case ResponseStatusCodes.successCode.rawValue:
            do {
                let responseModel = try parse(json: jsonResponse)
                let headers = urlResponse.allHeaderFields as? [String: String] ?? [:]
                success(result: responseModel, headers: headers, completion: completion)
            } catch(let error) {
                handleDecodingError(error: error, completion: completion)
            }
        case ResponseStatusCodes.timeOutCode.rawValue,
             ResponseStatusCodes.badRequest.rawValue,
             ResponseStatusCodes.internalServerError.rawValue:
            handleFailure(code: urlResponse.statusCode, message: "", completion: completion)
            
        case NSURLErrorNotConnectedToInternet:
            completion(.notConnectedToInternet)
            
        default:
            handleFailure(code: urlResponse.statusCode, message: "", completion: completion)
        }
    }
    
    private func handle(error: Error?, completion: @escaping (ServiceResponse<Model>) -> Void) {
        guard let responseError = error as NSError? else { return }
        
        switch responseError.code {
        case NSURLErrorNotConnectedToInternet:
            completion(.notConnectedToInternet)
        default:
            completion(.notConnectedToInternet)
            print(responseError.localizedDescription)
        }
    }
    
    open func parse(json: Data) throws -> [Model] {
        return try JSONDecoder().decode([Model].self, from: json)
    }
    
    private func handleDecodingError(error: Error, completion: @escaping (ServiceResponse<Model>) -> Void) {
        guard let decodingError = error as? DecodingError else {
            handleFailure(code: ResponseStatusCodes.unknownCode.rawValue, message: "", completion: completion)
            return
        }
        
        failure(error: ErrorResponse.generalError(code: .jsonParsing, tecnicalDescription: decodingError.debugDescription), completion: completion)
    }
    
    private func handleFailure(code: Int, message: String, completion: @escaping (ServiceResponse<Model>) -> Void) {
        let errorResponse = ErrorResponse.generalError(code: ResponseStatusCodes.getStatusForCode(code),
                                                       tecnicalDescription: message)
        failure(error: errorResponse, completion: completion)
    }
    
    private func failure(error: ErrorResponse, completion: @escaping (ServiceResponse<Model>) -> Void) {
        completion(.failure(error: error))
    }
    
    private func success(result: [Model],
                         headers: [String: String],
                         completion: @escaping (ServiceResponse<Model>) -> Void) {
        completion(ServiceResponse<Model>.success(response: result, headers: headers))
    }
}
