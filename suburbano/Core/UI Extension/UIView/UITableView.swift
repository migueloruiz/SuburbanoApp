//
//  UITableView.swift
//  suburbano
//
//  Created by Miguel Ruiz on 2/7/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusable<T: UITableViewCell>(view: T.Type) -> T? where T: ReusableView {
        return dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T
    }

    func register<T: UITableViewCell>(cell: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(cell: T.Type) where T: ReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
}
