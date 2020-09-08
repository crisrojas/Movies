//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation
import UIKit

struct MoviesViewModel {
    
    var moviesManager = MoviesManager()
    var model = Movies(results: [Movie]())
    let url = "https://api.themoviedb.org/3/movie/now_playing?api_key=b5f1e193c3a2759a19f3f085f3dc2d7e"
    
    init() {
        moviesManager.delegate = self
    }
    
    func fetch() {
        moviesManager.fetchMovies()
    }
    
    func numberOfSection() -> Int {
        return 0
    }
    
    func numberOfItems() -> Int {
        return 0
    }
    
    func cellFor() -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}


extension MoviesViewModel: MoviesManagerDelegate {
     func didDownloadMovies(movies: Movies) {
       //
    }
    
}
