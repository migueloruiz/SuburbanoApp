//
//  RealmAppDelegate.swift
//  suburbano
//
//  Created by Miguel Ruiz on 27/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit
import RealmSwift

final class RealmAppDelegate: NSObject, UIApplicationDelegate {
    
    static let shared = RealmAppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        realmSetup()
        return true
    }
}

extension RealmAppDelegate {
    func realmSetup() {
        guard let realmPath = getRealmURL(),
            let schemaVersion = getBundleVersion() else { return }
        do {
            try configure(schemaVersion: schemaVersion, realmFileURL: realmPath)
        } catch {
            handleMigrationFail()
        }
    }
    
    func configure(schemaVersion: Int, realmFileURL: URL) throws {
        var config = Realm.Configuration(
            schemaVersion: UInt64(schemaVersion),
            migrationBlock: { _, oldSchemaVersion in
                guard oldSchemaVersion < UInt64(schemaVersion) else { return }
        }, deleteRealmIfMigrationNeeded: false)
        
        config.fileURL = realmFileURL
        Realm.Configuration.defaultConfiguration = config
    }
    
    func handleMigrationFail() {
        deleteBrokenFile()
        realmSetup()
    }
    
    func deleteBrokenFile() {
        guard let realmURL = getRealmURL() else { return }
        deleteFileIfExists(path: realmURL.path)
    }
    
    // TODO
    func getRealmURL() -> URL? {
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.migueloruiz.subur") else { return nil }
        let realmURL = container.appendingPathComponent("Realm")
        createFoldersIfNecesary(forPath: realmURL.path)
        return realmURL.appendingPathComponent("default.realm")
    }
    
    // TODO
    func createFoldersIfNecesary(forPath path: String) {
        guard !FileManager.default.fileExists(atPath: path) else { return }
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func deleteFileIfExists(path: String) {
        guard FileManager.default.fileExists(atPath: path) else { return }
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error as NSError {
            print(error)
        }
    }
    
    // TODO
    func getBundleVersion() -> Int? {
        guard let envVariables = Bundle.main.infoDictionary,
            let rawBundleVersion = envVariables["CFBundleVersion"] as? String,
            let bundleVersion = Int(rawBundleVersion) else { return nil }
        return bundleVersion
    }
}
