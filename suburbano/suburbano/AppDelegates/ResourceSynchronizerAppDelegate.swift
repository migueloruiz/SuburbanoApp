//
//  ResourceSynchronizerAppDelegate.swift
//  suburbano
//
//  Created by Miguel Ruiz on 11/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

final class ResourceSynchronizerAppDelegate: NSObject, UIApplicationDelegate {
    
    static let shared = ResourceSynchronizerAppDelegate()
    let service = SymbolsWebService()
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        syncResourse()
    }
}

extension ResourceSynchronizerAppDelegate {
    func syncResourse() {
        service.getEvents { response in
            switch response {
            case .success(let data, let headers):
                print(headers)
                for symbol in data {
                    print(symbol)
                }
            case .failure(let error):
                print(error)
            case .notConnectedToInternet:
                print("notConnectedToInternet")
            }
        }
    }
}
