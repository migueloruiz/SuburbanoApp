//
//  CardBalanceView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 18/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

protocol CardBalanceViewDelegate: class {
    func addCard()
    func openCard(withId id: String)
}

class CardBalanceView: UIView {
    
    struct Constants {
        static let addButtonDiameter: CGFloat = Theme.IconSize.normal
    }
    
    private let addButton = UIButton()
    private let emptyMessageView = BalanceEmptyMessageView()
    weak var delegate: CardBalanceViewDelegate?
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    init() {
        super.init(frame: .zero)
        configureUI()
        configureLayout()
    }
    
    private func configureUI() {
        // TODO factory for circular buttons with icon
        addButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        addButton.setImage(#imageLiteral(resourceName: "plus"), for: .focused)
        addButton.imageView?.tintColor = .white
        addButton.imageView?.contentMode = .center
        addButton.backgroundColor = Theme.Pallete.softGray
        addButton.anchorSquare(size: Constants.addButtonDiameter)
        addButton.roundCorners(withRadius: Constants.addButtonDiameter / 2)
        addButton.target(forAction: #selector(CardBalanceView.addCard), withSender: nil)
        
        let addCardGesture = UITapGestureRecognizer(target: self, action: #selector(CardBalanceView.addCard))
        emptyMessageView.addGestureRecognizer(addCardGesture)
        emptyMessageView.isUserInteractionEnabled = true
        
        addButton.isHidden = false
        emptyMessageView.isHidden = true
    }
    
    private func configureLayout() {
        addSubViews([emptyMessageView, addButton])
        addButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor)
        emptyMessageView.fillSuperview()
    }
    
    func display(elements: [Int]) {
        guard !elements.isEmpty else {
            addButton.isHidden = true
            emptyMessageView.isHidden = false
            return
        }
        
        addButton.isHidden = true
        emptyMessageView.isHidden = false
    }
    
    @objc func addCard() {
        delegate?.addCard()
    }
}
