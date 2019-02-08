//
//  DebugManager.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/7/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

class DebugManager {
    static func log(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        guard LaunchArgumentsManager.isAvailable(argument: .debugMode) else { return }
        print("DEBUG: ", items, separator: separator, terminator: terminator)
    }
}
