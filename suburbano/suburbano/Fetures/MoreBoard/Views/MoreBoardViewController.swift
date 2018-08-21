//
//  MoreBoardViewController.swift
//  suburbano
//
//  Created by Miguel Ruiz on 14/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class MoreBoardViewController: NavigationalViewController {
    
    override var navgationIcon: UIImage { return #imageLiteral(resourceName: "MoreIcon") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}
