//
//  FadingCollectionView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/08/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import UIKit

class FadingCollectionView: UICollectionView {

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    init() {
        super.init(frame: .zero, collectionViewLayout: FadingCollectionLayout())
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
        contentInset = UIEdgeInsets.with(vertical: 0, horizoltal: CardBalancePikerConstas.interSapace)
    }
}
