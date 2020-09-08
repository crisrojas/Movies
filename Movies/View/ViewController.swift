//
//  ViewController.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel!
    var moviesManager = MoviesManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesManager.delegate = self
        moviesManager.fetchMovies()
    }
}

extension ViewController: MoviesManagerDelegate {
 
    func didDownloadMovies(movies: Movies) {
        DispatchQueue.main.async {
            self.testLabel.text = movies.results[0].title
        }
    }
}

