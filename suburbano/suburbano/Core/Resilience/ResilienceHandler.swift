//
//  ResilienceFileHandler.swift
//  suburbano
//
//  Created by Miguel Ruiz on 9/17/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol ResilienceFileHandler {
    func loadLocalJSON(from fileName: String) -> Data?
}

class ResilienceFileHandlerImpl: ResilienceFileHandler {

    struct Constants {
        static let fileExtention = "json"
    }

    func loadLocalJSON(from fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: Constants.fileExtention) else { return nil }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}
