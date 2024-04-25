//
//  _utilities.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import Foundation

protocol Initiable {init()}
extension Initiable {
    init(transform: (inout Self) -> Void) {
        var copy = Self.init()
        transform(&copy)
        self = copy
    }
}

import SwiftUI
protocol Component: SwiftUI.View, Initiable {}
protocol TapInjectable {
    var _onTap: () -> Void {get set}
}

extension TapInjectable {
    func onTap(cls: @escaping () -> Void) -> Self {
        var copy = self
        copy._onTap = cls
        return copy
    }
}

func youtubeURL(key: String) -> URL? {
    URL(string: "https://youtube.com/watch?v=\(key)")
}

infix operator *: AdditionPrecedence
func * <T>(lhs: T, rhs: (inout T) -> Void) -> T {
    var copy = lhs
    rhs(&copy)
    return copy
}
