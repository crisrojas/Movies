//
//  Movie.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let id: Int
    let posterPath : String?
    let title: String
    let overview: String
    var poster: String? {
        guard let posterPath = posterPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    var cast : [Actor]?
}
