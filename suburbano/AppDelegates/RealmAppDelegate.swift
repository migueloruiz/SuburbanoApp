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

    private enum RealmError: Error {
        case urlNotFound
        case handleMigrationFail
    }

    struct Constants {
        static let realmFolder = "Realm"
        static let realmFile = "default.realm"
    }

    static let shared = RealmAppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        realmSetup()
        return true
    }
}

extension RealmAppDelegate {

    func realmSetup() {
        do {
            let realmPath = try getRealmURL()
            let schemaVersion = try Environment.getBundleVersion()
            try configure(schemaVersion: schemaVersion, realmFileURL: realmPath)
        } catch let error {
            DebugLogger.record(error: error)
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
        do {
            let realmURL = try getRealmURL()
            try Utils.deleteFileIfExists(path: realmURL.path)
        } catch let error {
            DebugLogger.record(error: error)
        }
    }

    func getRealmURL() throws -> URL {
        let securityApplicationGroup = try Environment.getSecurityApplicationGroup()
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: securityApplicationGroup) else {
            throw RealmError.urlNotFound
        }
        let realmURL = container.appendingPathComponent(Constants.realmFolder)
        try Utils.createFoldersIfNecesary(forPath: realmURL.path)
        return realmURL.appendingPathComponent(Constants.realmFile)
    }
}
