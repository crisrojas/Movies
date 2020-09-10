//
//  MoviesDetailProtocol.swift
//  Movies
//
//  Created by cristian on 09/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation

protocol MoviesDetailView: class {
    
    func didUpdate(state: MoviesDetailViewModelState)
}

protocol MoviesDetailViewModelInput {
    
    var view: MoviesDetailView? { get set }
    var model: Credits { get }
    
    func fetchCredits(movieId: Int)
    
}
