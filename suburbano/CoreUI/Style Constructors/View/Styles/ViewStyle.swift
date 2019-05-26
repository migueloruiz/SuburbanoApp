//
//  ViewStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol ViewStyle {
    var backgroundColor: UIColor { get }
    var radius: CGFloat { get }
    var hasShadow: Bool { get }
}

enum ViewStyles {
    case card
    case container

    var style: ViewStyle {
        switch self {
        case .card: return CardStyle()
        case .container: return ContainerStyle()
        }
    }
}

private struct CardStyle: ViewStyle {
    let backgroundColor = Theme.Pallete.white
    let radius = Theme.Rounded.card
    let hasShadow = true
}

private struct ContainerStyle: ViewStyle {
    let backgroundColor = Theme.Pallete.white
    let radius = Theme.Rounded.controller
    let hasShadow = true
}
