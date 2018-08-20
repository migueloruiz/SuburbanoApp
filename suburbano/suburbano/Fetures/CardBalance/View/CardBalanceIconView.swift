//
//  CardBalanceIconView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 20/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol CardBalanceIconViewDelegate: class {
    func didTapCardBalanceIcon()
}

enum CardBalanceIcon {
    case initial
    case custome(image: UIImage?, color: UIColor)
}

class CardBalanceIconView: UIImageView {
    
    struct Constants {
        static let iconDiameter: CGFloat = Theme.IconSize.large
    }
    
    private weak var delegate: CardBalanceIconViewDelegate?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init(delegate: CardBalanceIconViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CardBalanceIconView.didTapElement))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
        contentMode = .center
//        addDropShadow(color: Theme.Pallete.softGray, offSet: CGSize(width: 0, height: 0))
        roundCorners(withRadius: Constants.iconDiameter / 2)
        tintColor = .white
        set(icon: .initial)
    }
    
    private func configureLayout() {
        anchorSquare(size: Constants.iconDiameter)
    }
    
    func set(icon: CardBalanceIcon) {
        switch icon {
        case .initial:
            image = #imageLiteral(resourceName: "plus")
            backgroundColor = Theme.Pallete.softGray
        case .custome(let iconImage, let color):
            image = iconImage
            backgroundColor = color
        }
    }
    
    @objc private func didTapElement() {
        delegate?.didTapCardBalanceIcon()
        becomeFirstResponder()
    }
}
