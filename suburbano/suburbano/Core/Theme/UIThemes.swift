//
//  UIThemes.swift
//  suburbano
//
//  Created by Miguel Ruiz on 04/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol LabelStyle {
    var numberOfLines: Int { get }
    var textAlignment: NSTextAlignment { get }
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var font: FontStyle { get }
}

struct LabelTheme: LabelStyle {
    let numberOfLines: Int
    let textAlignment: NSTextAlignment
    let textColor: UIColor
    let backgroundColor: UIColor
    let font: FontStyle
}

protocol ButtonStyle {
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var font: FontStyle { get }
    var rounded: RoundedStyle? { get }
}

struct ButtonTheme: ButtonStyle {
    let textColor: UIColor
    let backgroundColor: UIColor
    let font: FontStyle
    let rounded: RoundedStyle?
}

struct RoundedStyle {
    let radius: CGFloat
}

protocol FieldStyle {
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var font: FontStyle { get }
    var autocorrectionType: UITextAutocorrectionType { get }
    var keyboardType: UIKeyboardType { get }
}

struct FieldTheme: FieldStyle {
    let textColor: UIColor
    let tintColor : UIColor
    let backgroundColor: UIColor
    let font: FontStyle
    let autocorrectionType: UITextAutocorrectionType
    let keyboardType: UIKeyboardType
}

struct UIThemes {
    
    // MARK: - Field Themes
    struct Field {
        static let CardNumberField = FieldTheme(textColor: Theme.Pallete.darkGray,
                                             tintColor: Theme.Pallete.softRed,
                                             backgroundColor: .white,
                                             font: FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium),
                                             autocorrectionType: .no,
                                             keyboardType: .numberPad)
        
        // MARK: - Icon Picker Label Themes
        static let IconPickerField = FieldTheme(textColor: .white,
                                                  tintColor: .clear,
                                                  backgroundColor: .clear,
                                                  font: FontStyle(size: .smallIcon, largeFactor: Theme.FontFactor.large, name: .icons, style: .none),
                                                  autocorrectionType: .no,
                                                  keyboardType: .numberPad)
    }
    
    // MARK: - Label Themes
    struct Label {
        // MARK: - General Label Themes
        static let ActivityBoardNavTitle = LabelTheme(numberOfLines: 1,
                                         textAlignment: .center,
                                         textColor: .white,
                                         backgroundColor: Theme.Pallete.softRed,
                                         font: FontStyle(size: .h1, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        
        static let CardBalanceNavTitle = LabelTheme(numberOfLines: 1,
                                                      textAlignment: .center,
                                                      textColor: Theme.Pallete.darkGray,
                                                      backgroundColor: .white,
                                                      font: FontStyle(size: .h1, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium))
        
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
    }
    
    // MARK: - Button Themes
    struct Button {
        // MARK: - ActivityCard Button Themes
        static let ActivityCard = ButtonTheme(textColor: Theme.Pallete.darkGray,
                                              backgroundColor: .white,
                                              font: FontStyle(size: .p, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium),
                                              rounded: nil)
        
        // MARK: - Popup Button Themes
        static let PrimaryButton = ButtonTheme(textColor: .white,
                                              backgroundColor: Theme.Pallete.primaryAction,
                                              font: FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium),
                                              rounded: RoundedStyle(radius: Theme.Rounded.button))
        
        static let SecondayButton = ButtonTheme(textColor: .white,
                                                backgroundColor: Theme.Pallete.softRed,
                                                font: FontStyle(size: .general, largeFactor: Theme.FontFactor.large, name: .montserrat, style: .medium),
                                                rounded: RoundedStyle(radius: Theme.Rounded.button))
    }
}
