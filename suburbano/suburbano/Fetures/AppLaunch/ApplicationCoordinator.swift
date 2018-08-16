//
//  ApplicationCoordinator.swift
//  suburbano
//
//  Created by Miguel Ruiz on 09/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    var mainCordinator: MainCordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if true {
            mainCordinator = MainCordinator(window: window)
            mainCordinator?.start()
        }
    }
}
