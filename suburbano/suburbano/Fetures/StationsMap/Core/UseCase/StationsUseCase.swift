//
//  StationsUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol LoadStationsUseCase {
    func loadStations()
}

protocol GetStationsUseCase {
    func getStations() -> [Station]
}

protocol StationsUseCase: GetStationsUseCase, LoadStationsUseCase { }
