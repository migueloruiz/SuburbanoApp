//
//  AppLaunchArguments.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/7/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation

enum LaunchArgument: String {
    case debugMode = "DEBUG_MODE"
}

class LaunchArgumentsManager {
    static func isAvailable(argument: LaunchArgument) -> Bool {
        return ProcessInfo.processInfo.arguments.contains(argument.rawValue)
    }
}
