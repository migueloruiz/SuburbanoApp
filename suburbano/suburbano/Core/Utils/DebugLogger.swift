//
//  DebugManager.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/7/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import Crashlytics

class DebugLogger {
    static func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        #if DEBUG
        guard LaunchArgumentsManager.isAvailable(argument: .debugMode) else { return }
        print("DEBUG: ", items, separator: separator, terminator: terminator)
        #endif
    }

    static func crash() {
        #if DEBUG
        Crashlytics.sharedInstance().crash()
        #endif
    }

    static func record(error: Error, additionalInfo: [String: Any]? = nil) {
        Crashlytics.sharedInstance().recordError(error, withAdditionalUserInfo: additionalInfo)
    }
}
