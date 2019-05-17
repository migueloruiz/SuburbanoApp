//
//  NavigationButtonStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/16/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol NavigationButtonStyle {
    var icon: UIImage { get }
    var iconColor: UIColor { get }
}

enum NavigationButtonStyles {
    case down

    var style: NavigationButtonStyle {
        switch self {
        case .down: return  DownNavigationButtonStyle()
        }
    }
}

private struct DownNavigationButtonStyle: NavigationButtonStyle {
    let icon = #imageLiteral(resourceName: "down-arrow")
    let iconColor = Theme.Pallete.darkGray
}
