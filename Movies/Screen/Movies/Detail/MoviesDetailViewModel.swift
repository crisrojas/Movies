//
//  MoviesDetailViewModel.swift
//  Movies
//
//  Created by cristian on 09/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation

enum MoviesDetailViewModelState {
    
    case loading, success, error
    var isLoading: Bool {
        self == .loading
    }
}


class MoviesDetailViewModel: MoviesDetailViewModelInput {
    
    private let moviesRepository: MoviesRepositoryInput
    private(set) var model = Credits(cast: [Actor]())
    weak var view: MoviesDetailView?
    
    init(moviesRepository: MoviesRepositoryInput) {
        self.moviesRepository = moviesRepository
    }
    
    func fetchCredits(movieId: Int) {
        view?.didUpdate(state: .loading)
        self.moviesRepository.fetchCredits(movieId: movieId)
    }
}

extension MoviesDetailViewModel: MoviesRepositoryOutput {
    func didDownloadCredits(credits: Credits) {
        model = credits
        DispatchQueue.main.async { [weak self] in
            self?.view?.didUpdate(state: .success)
        }
    }
}
