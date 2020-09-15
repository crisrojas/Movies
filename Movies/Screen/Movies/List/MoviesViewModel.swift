//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation
import UIKit

enum MoviesViewModelState {
    
    case loading, success, error
    var isLoading: Bool {
        self == .loading
    }
}


class MoviesViewModel: MoviesViewModelInput {
    
    private let moviesRepository: MoviesRepositoryInput
    private(set) var model = Movies(results: [Movie]())
    weak var view: MoviesView?
    
    init(moviesRepository: MoviesRepositoryInput = MoviesRepository()) {
        self.moviesRepository = moviesRepository
    }
    
    func fetchMovies() {
        view?.didUpdate(state: .loading)
        moviesRepository.fetchMovies()
    }
    
}


extension MoviesViewModel: MoviesRepositoryOutput {
     func didDownloadMovies(movies: Movies) {
        model = movies
        DispatchQueue.main.async { [weak self] in
            self?.view?.didUpdate(state: .success)
        }
    }
}
