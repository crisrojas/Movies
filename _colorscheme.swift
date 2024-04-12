//
//  _colorscheme.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 12/04/2024.
//

import SwiftUI

extension ColorScheme: RawRepresentable {
    public var rawValue: String {
        switch self {
        case .light: return "light"
        case .dark: return "dark"
        default: return "unknown"
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case "light": self = .light
        case "dark": self = .dark
        default: return nil
        }
    }
}
