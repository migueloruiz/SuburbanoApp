//
//  AppImages.swift
//  suburbano
//
//  Created by Miguel Ruiz on 19/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

struct AppImages {
    struct Strech {
        static let cardBase = #imageLiteral(resourceName: "BottomLineCard").resizableImage(withCapInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8), resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
    }
}
