//
//  RealmHandler.swift
//  suburbano
//
//  Created by Miguel Ruiz on 12/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation
import RealmSwift

class RealmHandler: NSObject {
    
    private var realmInstance: Realm? {
        guard let realmInstance = try? Realm() else {
            assertionFailure("Somethig went wrong by getting Realm instance")
            return nil
        }
        return realmInstance
    }
    
    func add(object: Object, update: Bool = true) {
        guard let realm = realmInstance else { return }
        if realm.isInWriteTransaction {
            realm.add(object, update: update)
        } else {
            do {
                try realm.write { realm.add(object, update: update) }
            } catch let error as NSError {
                assertionFailure("Somethig went wrong with Realm (Write), error = \(error.description)")
            }
        }
    }
    
    func add(objects: [Object], update: Bool = true) {
        guard let realm = realmInstance else { return }
        if realm.isInWriteTransaction {
            realm.add(objects, update: update)
        } else {
            do {
                try realm.write { realm.add(objects, update: update) }
            } catch let error as NSError {
                assertionFailure("Somethig went wrong with Realm (Write), error = \(error.description)")
            }
        }
    }
    
    func get<Element>(ofType type: Element.Type, forKey key: String) -> Element? where Element : RealmSwift.Object {
        guard let realm = realmInstance, !key.isEmpty else { return nil }
        return realm.object(ofType: type, forPrimaryKey: key)
    }

    func get<Element>(type: Element.Type, predicateFormat: NSPredicate? = nil) -> [Element]? where Element : RealmSwift.Object {
        guard let realm = realmInstance else { return nil }
        var result = realm.objects(type)
        if let predicate = predicateFormat {
            result = result.filter(predicate)
        }
        return Array(result)
    }
    
    func delete(object: Object) {
        guard let realm = realmInstance else { return }
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error as NSError {
            assertionFailure("Somethig went wrong with Realm (Delete), error = \(error.description)")
        }
    }
    
    func delete<Element>(objects: [Element]) where Element : RealmSwift.Object {
        guard let realm = realmInstance else { return }
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch let error as NSError {
            assertionFailure("Somethig went wrong with Realm (Delete), error = \(error.description)")
        }
    }
    
    func deleteAll<Element>(forType type: Element.Type) where Element : RealmSwift.Object {
        guard let realm = realmInstance else { return }
        let allObjects = realm.objects(type)
        do {
            try realm.write {
                realm.delete(allObjects)
            }
        } catch let error as NSError {
            assertionFailure("Somethig went wrong with Realm (DeleteAllForType), error = \(error.description)")
        }
    }
    
    func clearData() {
        guard let realm = realmInstance else { return }
        do {
            if realm.isInWriteTransaction {
                realm.cancelWrite()
            }
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            assertionFailure("Somethig went wrong with Realm (DeleteAll), error = \(error.description)")
        }
    }
}
