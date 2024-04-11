//
//  _entities.swift
//  Movies
//
//  Created by Cristian Felipe Patiño Rojas on 10/04/2024.
//

import Foundation
import SwiftUI

enum FeaturedGenre: String, CaseIterable, Identifiable {
    case fantasy = "Fantasy"
    case adventure = "Adventure"
    case action = "Action"
    case sciFi = "Sci-Fi"
    
    var id: Int {
        switch self {
        case .fantasy: return 14
        case .adventure: return 12
        case .action: return 28
        case .sciFi: return 878
        }
    }
    
    var color: Color {
        switch self {
        case .fantasy: return WindColor.yellow.c500
        case .adventure: return WindColor.orange.c500
        case .action: return WindColor.teal.c500
        case .sciFi: return WindColor.red.c500
        }
    }
}
