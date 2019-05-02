//
//  UICollectionView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/7/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusable<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T? where T: ReusableView {
        return dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
    }

    func registerSupplementaryView<T: UICollectionReusableView>(view: T.Type, kind: String) where T: ReusableView {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueSupplementaryView<T: UICollectionReusableView>(view: T.Type, kind: String, for indexPath: IndexPath) -> T? where T: ReusableView {
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: T.reuseIdentifier,
                                                for: indexPath) as? T
    }

}
