//
//  DecodingError.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

extension DecodingError {
    var debugDescription: String {
        switch self {
        case .dataCorrupted(let context): return context.debugDescription
        case .keyNotFound(_, let context): return context.debugDescription
        case .typeMismatch(_, let context), .valueNotFound(_, let context): return context.debugDescription
        }
    }
}
