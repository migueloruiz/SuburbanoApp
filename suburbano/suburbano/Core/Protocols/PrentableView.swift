//
//  PrentableView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol PrentableView {
    var inTransition: UIViewControllerAnimatedTransitioning? { get }
    var outTransition: UIViewControllerAnimatedTransitioning? { get }
}
