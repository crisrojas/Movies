//
//  _utilities.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import Foundation

func youtubeURL(key: String) -> URL? {
    URL(string: "https://youtube.com/watch?v=\(key)")
}

infix operator *: AdditionPrecedence
func * <T>(lhs: T, rhs: (inout T) -> Void) -> T {
    var copy = lhs
    rhs(&copy)
    return copy
}
