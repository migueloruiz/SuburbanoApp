//
//  UIThemes.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

// TODO: Refactor

struct LabelTheme: LabelStyle {
    let numberOfLines: Int
    let textAlignment: NSTextAlignment
    let textColor: UIColor
    let backgroundColor: UIColor
    let font: FontStyle
}

struct RoundedStyle {
    let radius: CGFloat
}

struct UIThemes {

    // MARK: - Label Themes
    struct Label {

        // MARK: - ActivityCard Label Themes
        static let ActivityCardTitle = LabelTheme(numberOfLines: 0,
                                                  textAlignment: .left,
                                                  textColor: Theme.Pallete.darkGray,
                                                  backgroundColor: .white,
                                                  font: FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))

        static let ActivityCardDetails = LabelTheme(numberOfLines: 0,
                                                    textAlignment: .left,
                                                    textColor: Theme.Pallete.darkGray,
                                                    backgroundColor: .white,
                                                    font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .openSansCondensed, style: .bold))
        static let ActivityCardBody = LabelTheme(numberOfLines: 0,
                                                 textAlignment: .left,
                                                 textColor: Theme.Pallete.softGray,
                                                 backgroundColor: .white,
                                                 font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))

        // MARK: - Wait
        static let WaitTime = LabelTheme(numberOfLines: 0,
                                        textAlignment: .center,
                                        textColor: Theme.Pallete.darkGray,
                                        backgroundColor: .white,
                                        font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .openSansCondensed, style: .bold))

        // MARK: - Popup Label Themes
        static let PopupTitle = LabelTheme(numberOfLines: 0,
                                                  textAlignment: .center,
                                                  textColor: Theme.Pallete.softRed,
                                                  backgroundColor: .white,
                                                  font: FontStyle(size: .h3, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        static let PopupBody = LabelTheme(numberOfLines: 0,
                                                 textAlignment: .center,
                                                 textColor: Theme.Pallete.darkGray,
                                                 backgroundColor: .white,
                                                 font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))

        // MARK: - Map Label Themes
        static let StationMarkerTitle = LabelTheme(numberOfLines: 0,
                                           textAlignment: .center,
                                           textColor: Theme.Pallete.darkGray,
                                           backgroundColor: .clear,
                                           font: FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .bold))

        // MARK: - Icon Picker Label Themes
        static let IconPicker = LabelTheme(numberOfLines: 0,
                                           textAlignment: .center,
                                           textColor: Theme.Pallete.softGray,
                                           backgroundColor: .white,
                                           font: FontStyle(size: .icon, largeFactor: Theme.FontFactor.large, name: .icons, style: .none))

        // MARK: - Card Picker Label Themes
        static let CardPickerIcon = LabelTheme(numberOfLines: 0,
                                           textAlignment: .center,
                                           textColor: .white,
                                           backgroundColor: .white,
                                           font: FontStyle(size: .smallIcon, largeFactor: Theme.FontFactor.large, name: .icons, style: .none))

        static let CardPickerTitle = LabelTheme(numberOfLines: 0,
                                                  textAlignment: .right,
                                                  textColor: Theme.Pallete.darkGray,
                                                  backgroundColor: .clear,
                                                  font: FontStyle(size: .h3, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .bold))

        // MARK: - Staion Detail Label Themes

        static let StaionDetailStation = LabelTheme(numberOfLines: 1,
                                                    textAlignment: .left,
                                                    textColor: Theme.Pallete.softGray,
                                                    backgroundColor: .white,
                                                    font: FontStyle(size: .h3, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))

        // MARK: - Directions discraimer Label Themes
        static let DirectionsDisclainer = LabelTheme(numberOfLines: 0,
                                                 textAlignment: .left,
                                                 textColor: .white,
                                                 backgroundColor: .clear,
                                                 font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        // MARK: - Info Title Label Themes
        static let InfoTitle = LabelTheme(numberOfLines: 0,
                                            textAlignment: .center,
                                            textColor: Theme.Pallete.softRed,
                                            backgroundColor: .clear,
                                            font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        static let InfoAmount = LabelTheme(numberOfLines: 0,
                                          textAlignment: .center,
                                          textColor: Theme.Pallete.darkGray,
                                          backgroundColor: Theme.Pallete.ligthGray,
                                          font: FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
    }
}
