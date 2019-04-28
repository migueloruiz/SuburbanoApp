//
//  Environment.swift
//  suburbano
//
//  Created by Miguel Ruiz on 4/28/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

enum EnvironmentError: Error {
    case plistNotFound
    case baseUrlsNotFound
    case hostURLParsing
    case valueNotFound
}

public struct Environment {

    private struct Keys {
        static let BaseUrls = "BaseUrls"
        static let bundleVersion = "CFBundleVersion"

        static let MainHost = "MainHost"
        static let FsuburbanosHost = "FsuburbanoHost"
        static let SecurityApplicationGroup = "SecurityApplicationGroup"
    }

    private static let infoDictionary: [String: Any] = {
        return (try? getInfoDictionary()) ?? [:]
    }()

    private static func getInfoDictionary() throws -> [String: Any] {
        guard let dict = Bundle.main.infoDictionary else { throw EnvironmentError.plistNotFound }
        return dict
    }

    static func getBundleVersion() throws -> Int {
        guard let rawBundleVersion = infoDictionary[Keys.bundleVersion] as? String,
            let bundleVersion = Int(rawBundleVersion) else {
            throw EnvironmentError.valueNotFound
        }
        return bundleVersion
    }

    static func host(withType hostType: Host) throws -> URL {
        guard let baseUrls = infoDictionary[Keys.BaseUrls] as? [String: String] else {
            throw EnvironmentError.baseUrlsNotFound
        }

        var rawUrl: String?
        switch hostType {
        case .main:
            rawUrl = baseUrls[Keys.MainHost]
        case .fsuburbanos:
            rawUrl = baseUrls[Keys.FsuburbanosHost]
        }

        guard let url = URL(string: rawUrl  ?? "") else { throw EnvironmentError.hostURLParsing }
        return url
    }

    static func getSecurityApplicationGroup() throws -> String {
        guard let securityApplicationGroup = infoDictionary[Keys.SecurityApplicationGroup] as? String else {
            throw EnvironmentError.valueNotFound
        }
        return securityApplicationGroup
    }
}
