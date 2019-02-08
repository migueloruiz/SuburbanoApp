//
//  UICollectionView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/7/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UICollectionView {
    func dequeueReusable<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? where T: ReusableView {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }

    func register<T: UICollectionViewCell>(cell: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}
