//
//  File.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class Utils {

    private enum UtilsError: Error {
        case fileNotFound
        case budleNotFound
    }

    static func getBundle(appBundle: AppBundle) throws -> Bundle {
        guard appBundle != .main else { return Bundle.main }
        guard let bundleURL = Bundle.main.url(forResource: appBundle.identifier, withExtension: appBundle.extention),
        let bundle = Bundle(url: bundleURL) else {
            throw UtilsError.budleNotFound
        }
        return bundle
    }

    static func bundleUrl(forResource resource: AppResource) throws -> URL {
        let bundle = try getBundle(appBundle: resource.bundle)
        guard let url = bundle.url(forResource: resource.fileName, withExtension: resource.extention) else {
            throw UtilsError.fileNotFound
        }
        return url
    }

    static func bundlePath(forResource resource: AppResource) throws -> String {
        guard let path = Bundle.main.path(forResource: resource.fileName, ofType: resource.extention) else {
            throw UtilsError.fileNotFound
        }
        return path
    }

    static func createFoldersIfNecesary(forPath path: String) throws {
        guard !FileManager.default.fileExists(atPath: path) else { return }
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }

    static func deleteFileIfExists(path: String) throws {
        guard FileManager.default.fileExists(atPath: path) else { throw UtilsError.fileNotFound }
        try FileManager.default.removeItem(atPath: path)
    }
}
