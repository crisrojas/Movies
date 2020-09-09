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
    
    let baseURL = "https://api.themoviedb.org/3/movie"
    let apiKey = "?api_key=b5f1e193c3a2759a19f3f085f3dc2d7e"
    let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    var delegate : MoviesManagerDelegate?
    
    func fetchMovies() {
        let request = "/now_playing"
        let urlString = baseURL + request + apiKey
        let url = URL(string: urlString)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let safeData = data else { return }
            guard let movies = try? self.decoder.decode(Movies.self, from: safeData) else { return }
            DispatchQueue.main.async {
                self.delegate?.didDownloadMovies(movies: movies)
            }
                
            
        }
        task.resume()
    }
    
   /* func fetchCredtis(movieId: Int) {
        let request = "/\(movieId)/credits"
        let urlString = baseURL + request + apiKey
        let url = URL(string: urlString)!
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let safeData = data else { return }
            guard let credits = try? self.decoder.decode(Credits.self, from: safeData) else { return }
            DispatchQueue.main.async {
               self.delegate?.didDownloadCredits(credits: credits)
            }
        
        }
        task.resume()
        
    }
    */
}
