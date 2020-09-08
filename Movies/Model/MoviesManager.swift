//
//  MoviesManager.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Foundation

protocol MoviesManagerDelegate {
    func didDownloadMovies(movies: Movies)
}

struct MoviesManager {
    let url = "https://api.themoviedb.org/3/movie/now_playing?api_key=b5f1e193c3a2759a19f3f085f3dc2d7e"
    
    var delegate : MoviesManagerDelegate?
    
    func fetchMovies() {
        let url = URL(string: self.url)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil { print(error!) ; return }
            if let safeData = data {
                if let movies = self.parseJSON(data: safeData) {
                    self.delegate?.didDownloadMovies(movies: movies)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(data: Data) -> Movies? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Movies.self, from: data)
            let results = decodedData.results
            let movies = Movies(results: results)
            print(results[0].title)
            return movies
        } catch {
            return nil
        }
    }
}
