//
//  MoviesProtocol.swift
//  Movies
//
//  Created by cristian on 09/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation

protocol MoviesView: class {
    
    func didUpdate(state: MoviesViewModelState)
}

protocol MoviesViewModelInput {
    
    var view: MoviesView? { get set }
    var model: Movies { get }
    
    func fetchMovies()
}
