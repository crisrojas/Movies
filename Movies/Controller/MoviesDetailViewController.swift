//
//  MoviesDetailViewController.swift
//  Movies
//
//  Created by cristian on 08/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieOverview: UILabel!
    
    var creditsManager = CreditsManager()
    var credits: Credits?
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creditsManager.delegate = self
        creditsManager.fetchCredits(id: movie!.id)
        movieTitle.text = movie?.title
        guard let urlString = movie?.poster else { return }
        let url = URL(string: urlString)
        moviePoster.kf.setImage(with: url)
        movieOverview.text = movie?.overview
    
    }
}

extension MoviesDetailViewController: CreditsManagerDelegate {
    func didDownloadCredits(credits: Credits) {
        self.credits = credits
        print(credits)
    }
}
