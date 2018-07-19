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
}
