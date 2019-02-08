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
    }

    let resilienceHandler: ResilienceFileHandler

    init(resilienceHandler: ResilienceFileHandler) {
        self.resilienceHandler = resilienceHandler
    }

    func getStations() -> [Station] {
        guard let rawSattions = resilienceHandler.loadLocalJSON(from: Constants.fileName) else { return [] }
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
