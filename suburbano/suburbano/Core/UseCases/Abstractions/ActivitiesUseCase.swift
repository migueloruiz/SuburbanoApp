//
//  ActivitiesUseCase.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol LoadActivitiesUseCase {
    func load()
}

protocol GetActivitiesUseCase {
    func get() -> [Activity]
}

protocol ActivitiesUseCase: LoadActivitiesUseCase, GetActivitiesUseCase {}
