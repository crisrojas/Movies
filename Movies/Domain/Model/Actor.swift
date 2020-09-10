//
//  Actor.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation

struct Actor: Codable {
    
    let name: String
    let profilePath: String?
    
    var profilePicture: String? {
        // Attention aux fautes de frappe: utiliser autocompletion/copierColler!
        guard let profilePath = profilePath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(profilePath)"
    }
}
