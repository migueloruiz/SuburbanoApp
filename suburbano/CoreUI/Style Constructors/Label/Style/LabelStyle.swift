//
//  LabelStyle.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/26/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

protocol LabelStyle {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var font: FontStyle { get }
    var numberOfLines: Int { get }
    var textAlignment: NSTextAlignment { get }
}

enum LabelStyles {
    case title

    var style: LabelStyle {
        switch self {
        case .title: return  TitleLabelStyle()
        }
    }
}

private struct TitleLabelStyle: LabelStyle {
    let backgroundColor = Theme.Pallete.white
    let textColor = Theme.Pallete.darkGray
    let font = FontStyle(size: .h1, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium)
    let numberOfLines = 1
    let textAlignment: NSTextAlignment = .center
}
