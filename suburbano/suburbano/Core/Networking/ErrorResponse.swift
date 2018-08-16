//
//  ErrorResponse.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

public enum ResponseStatusCodes: Int {
    case successCode = 200
    case badRequest = 400
    case internalServerError = 500
    case networkConection = -1009
    case jsonParsing = -2000
    case nilRequest = -5000
    case unknownCode = 0
    
    static func getStatusForCode(_ rawValue: Int) -> ResponseStatusCodes {
        switch rawValue {
        case 200: return .successCode
        case 400: return .badRequest
        case 500: return .internalServerError
        case -1009: return .networkConection
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
    
    static func general(code: ResponseStatusCodes = ResponseStatusCodes.unknownCode, tecnicalDescription: String = "") -> ErrorResponse {
        return ErrorResponse(code: code,
                             header: "ERRORS_GENERAL_ERROR_HEADER",
                             body: "ERRORS_GENERAL_ERROR_BODY",
                             tecnicalDescription: tecnicalDescription)
    }
    
    static func networkConection(code: ResponseStatusCodes = .networkConection, tecnicalDescription: String = "") -> ErrorResponse {
        return ErrorResponse(code: code,
                             header: "ERRORS_GENERAL_ERROR_HEADER",
                             body: "ERRORS_GENERAL_ERROR_BODY",
                             tecnicalDescription: tecnicalDescription)
    }
}
