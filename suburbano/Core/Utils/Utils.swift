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

    static func bundleUrl(forResource resource: AppResource) throws -> URL {
        guard let url = Bundle.main.url(forResource: resource.fileName, withExtension: resource.extention) else {
            throw UtilsError.budleNotFound
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
