//
//  StationsUseCaseImpl.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class StationsUseCaseImpl: StationsUseCase {
    
    struct Constants {
        static let fileName = "stations"
        static let fileExtention = "json"
    }
    
    func getStations() -> [Station] {
        guard let rawSattions = loadLocalJSON(from: Constants.fileName) else { return [] }
        do {
            let json = try JSONDecoder().decode([Station].self, from: rawSattions)
            return json
        } catch let error {
            print(error.localizedDescription)
            return []
        }
    }
    
    func loadStations() {}
}

extension StationsUseCaseImpl {
    fileprivate func loadLocalJSON(from fileName: String) -> Data? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: Constants.fileExtention) else { return nil }
        do {
            let file = try Data(contentsOf: URL(fileURLWithPath: path))
            return file
        } catch {
            return nil
        }
    }
}
