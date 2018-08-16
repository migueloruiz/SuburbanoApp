//
//  Date.swift
//  suburbano
//
//  Created by Miguel Ruiz on 30/07/18.
//  Copyright © 2018 chimichanga studio. All rights reserved.
//

import Foundation

extension Date {
    func adding(segs: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(segs))
    }
}
