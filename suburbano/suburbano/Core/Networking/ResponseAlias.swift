//
//  ResponseAlias.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/7/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

typealias SuccessResponse<Model> = (_ response: Model) -> Void

typealias ErrorResponse = (_ error: Error) -> Void
typealias InlineErrorResponse = (String) -> Void

typealias InlineError = String
