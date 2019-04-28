//
//  File.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

class Utils {
    static func bundleUrl(forResource resource: AppResource) -> URL? {
        return Bundle.main.url(forResource: resource.fileName, withExtension: resource.extention)
    }

    static func bundlePath(forResource resource: AppResource) -> String? {
        return Bundle.main.path(forResource: resource.fileName, ofType: resource.extention)
    }

    static func createFoldersIfNecesary(forPath path: String) {
        guard !FileManager.default.fileExists(atPath: path) else { return }
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }

    static func deleteFileIfExists(path: String) {
        guard FileManager.default.fileExists(atPath: path) else { return }
        try? FileManager.default.removeItem(atPath: path)
    }
}
