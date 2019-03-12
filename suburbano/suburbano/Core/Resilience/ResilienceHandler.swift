//
//  ResilienceFileHandler.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class ResilienceFileHandler {

    func load<Model: Codable>(resource: AppResource, parser: ParserMethod<Model>? = nil) throws ->  Model {
        guard let url = Utils.bundleUrl(forResource: resource) else {
            throw ParsingError.noExistingFile
        }
        let rawJson = try Data(contentsOf: url)
        let parserMethod = parser ?? { body in
            guard let json = body else { throw ParsingError.noExistingBody }
            return try JSONDecoder().decode(Model.self, from: json)
        }
        return try parserMethod(rawJson)
    }
}
