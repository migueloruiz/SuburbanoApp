//
//  RepositoryRealm.swift
//  suburbano
//
//  Created by Miguel Ruiz on 16/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmRepository {}

extension RealmRepository where Self: Repository {
    func add(object: Object, update: Bool = true) {
        RealmHandler.shared.add(object: object, update: update)
    }

    func add(objects: [Object], update: Bool = true) {
        RealmHandler.shared.add(objects: objects, update: update)
    }

    func get<Element>(ofType type: Element.Type, forKey key: String) -> Element? where Element: RealmSwift.Object {
        return RealmHandler.shared.get(ofType: type, forKey: key)
    }

    func get<Element>(type: Element.Type, predicateFormat: NSPredicate? = nil, sortingKey: String? = nil, ascending: Bool = false) -> [Element]? where Element: RealmSwift.Object {
        return RealmHandler.shared.get(type: type, predicateFormat: predicateFormat, sortingKey: sortingKey, ascending: ascending)
    }

    func delete(object: Object) {
        RealmHandler.shared.delete(object: object)
    }

    func delete<Element>(objects: [Element]) where Element: RealmSwift.Object {
        RealmHandler.shared.delete(objects: objects)
    }

    func deleteAll<Element>(forType type: Element.Type) where Element: RealmSwift.Object {
        RealmHandler.shared.deleteAll(forType: type)
    }

    func clearData() {
        RealmHandler.shared.clearData()
    }
}
