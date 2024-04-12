//
//  _utilities.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import Foundation


infix operator *: AdditionPrecedence
func * <T>(lhs: T, rhs: (inout T) -> Void) -> T {
    var copy = lhs
    rhs(&copy)
    return copy
}
