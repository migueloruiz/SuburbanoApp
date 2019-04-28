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

    struct Constants {
        static let securityApplicationGroup = "group.com.miguelo.suburbano"
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
        Utils.deleteFileIfExists(path: realmURL.path)
    }

    func getRealmURL() -> URL? {
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.securityApplicationGroup) else { return nil }
        let realmURL = container.appendingPathComponent(Constants.realmFolder)
        Utils.createFoldersIfNecesary(forPath: realmURL.path)
        return realmURL.appendingPathComponent(Constants.realmFile)
    }

    func getBundleVersion() -> Int? {
        guard let envVariables = Bundle.main.infoDictionary,
            let rawBundleVersion = envVariables[AppConstants.App.bundleVersion] as? String,
            let bundleVersion = Int(rawBundleVersion) else { return nil }
        return bundleVersion
    }
}
