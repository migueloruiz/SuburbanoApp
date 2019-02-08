//
//  RepositoryRealm.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

protocol RepositoryRealm {
    associatedtype RealElement
    associatedtype Element

    var realmHandler: RealmHandler { get }

    func get(forKey key: String) -> Element?
    func get(predicateFormat: NSPredicate?) -> [Element]?
    func add(object: Element, update: Bool)
    func add(objects: [Element], update: Bool)
    func delete(object: Element)
    func delete(objects: [Element])
    func deleteAll()

    func map(object: RealElement) -> Element
    func map(object: Element) -> RealElement
}
