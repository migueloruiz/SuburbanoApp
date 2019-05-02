//
//  SafeAsignable.swift
//  suburbano
//
//  Created by Miguel Ruiz on 5/1/19.
//  Copyright © 2019 chimichanga studio. All rights reserved.
//

import Foundation
import Darwin

infix operator =!=
//
///// Asaigns the value if not equal
/////
///*:
// guard lhs != rhs else { return }
// lhs = rhs
// */
//public protocol SafeAsignable {
//
//    /// Asaigns the value if not equal
//    ///
//    /*:
//     guard lhs != rhs else { return }
//     lhs = rhs
//    */
//    ///
//    /// - Parameters:
//    ///   - lhs: A value to compare.
//    ///   - rhs: Another value to compare.
//    static func =!= (lhs: inout Self, rhs: Self)
//}

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
