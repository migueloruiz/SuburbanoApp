//
//  Repository.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/21/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

protocol BaseRepository {
    associatedtype DBModel
    associatedtype Model

    func mapToModel(dbModel: DBModel) -> Model
    func mapToDB(model: Model) -> DBModel
}

protocol GetWithKeyRepository {
    associatedtype Model
    func getEntity(withKey key: String) -> Model?
}

protocol GetMatchPredicateRepository {
    associatedtype Model
    func getEntity(whoMatchPredicate predicate: NSPredicate?) -> [Model]?
}

protocol AddRepository {
    associatedtype Model
    func add(model: Model, update: Bool)
    func add(model: [Model], update: Bool)
}

protocol DeleteRepository {
    associatedtype Model
    func delete(object: Model)
    func delete(objects: [Model])
    func deleteAll()
}
