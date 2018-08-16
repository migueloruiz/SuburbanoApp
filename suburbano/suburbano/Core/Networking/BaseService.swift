//
//  BaseService.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

enum ServiceResponse<Model> {
    case success(response: [Model], headers: [String: String])
    case failure(error: ErrorResponse)
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
            failure(error: .general(), completion: completion)
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
        case ResponseStatusCodes.badRequest.rawValue,
             ResponseStatusCodes.internalServerError.rawValue,
             NSURLErrorNotConnectedToInternet:
            handleFailure(code: urlResponse.statusCode, completion: completion)
            
        default:
            handleFailure(code: urlResponse.statusCode, completion: completion)
        }
    }
    
    open func parse(json: Data) throws -> [Model] {
        return try JSONDecoder().decode([Model].self, from: json)
    }
    
    private func handle(error: Error?, completion: @escaping (ServiceResponse<Model>) -> Void) {
        guard let responseError = error as NSError? else { return }
        let errorResponse: ErrorResponse = responseError.code == NSURLErrorNotConnectedToInternet ? .networkConection() : .general()
        failure(error: errorResponse, completion: completion)
    }
    
    private func handleDecodingError(error: Error, completion: @escaping (ServiceResponse<Model>) -> Void) {
        guard let decodingError = error as? DecodingError else {
            failure(error: .general(), completion: completion)
            return
        }
        failure(error: ErrorResponse.general(code: .jsonParsing, tecnicalDescription: decodingError.debugDescription), completion: completion)
    }
    
    private func handleFailure(code: Int, completion: @escaping (ServiceResponse<Model>) -> Void) {
        let errorResponse = ErrorResponse.general(code: ResponseStatusCodes.getStatusForCode(code),
                                                       tecnicalDescription: "")
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
