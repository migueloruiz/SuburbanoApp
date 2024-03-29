//
//  ResilienceRepository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol ResilienceRepository {}

extension ResilienceRepository where Self: Repository {
    func load<Model: Codable>(resource: AppResource, parser: ParserMethod<Model>? = nil) throws ->  Model {
        let url = try Utils.bundleUrl(forResource: resource)
        let rawJson = try Data(contentsOf: url)
        let parserMethod = parser ?? { body in
            guard let json = body else { throw ParsingError.noExistingBody }
            return try JSONDecoder().decode(Model.self, from: json)
        }
        return try parserMethod(rawJson)
    }
}
