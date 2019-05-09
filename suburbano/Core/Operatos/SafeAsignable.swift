//
//  SafeAsignable.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/8/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import Darwin

infix operator =!=

/// Asaigns the value if not equal
///
/*:
 if lhs != rhs {
 lhs = rhs
 }
 */
///
/// - Parameters:
///   - lhs: A value to compare.
///   - rhs: Another value to compare.

func =!= <T: Equatable>(lhs: inout T, rhs: T) {
    guard lhs != rhs else { return }
    lhs = rhs
}
