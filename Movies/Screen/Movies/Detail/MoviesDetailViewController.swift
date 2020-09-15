//
//  MoviesDetailViewController.swift
//  Movies
//
//  Created by cristian on 08/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Kingfisher
import UIKit


protocol MoviesDetailView: class {
    
    func didUpdate(state: MoviesDetailViewModelState)
}

class MoviesDetailViewController: UIViewController {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var viewModel: MoviesDetailViewModelInput = {
        var moviesRepository = MoviesRepository()
        let viewModel = MoviesDetailViewModel(moviesRepository: moviesRepository)
        moviesRepository.output = viewModel
        viewModel.view = self
        return viewModel
    }()
    
    var movie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        viewModel.fetchCredits(movieId: movie!.id)
        
        
        movieTitle.text = movie?.title
        movieOverview.text = movie?.overview
        
        guard let urlString = movie?.poster else { return }
        let url = URL(string: urlString)
        moviePoster.kf.setImage(with: url)
    
    }
}

// MARK: MoviesDetailView

extension MoviesDetailViewController: MoviesDetailView {
    func didUpdate(state: MoviesDetailViewModelState) {
        if state.isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        switch state {
        case .success:
            collectionView.reloadData()
            break
        case .error:
            break
        default:
            break
        }
    }
}


// MARK: UICollectionView methods

extension MoviesDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CastCell
        
        //todo: abstract to class setCell()
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2
        cell.imageView.clipsToBounds = true
        cell.imageView.image = UIImage(named: "Placeholder avatar")!
        
        if let urlString = viewModel.model.cast[indexPath.row].profilePicture {
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url)
        } else {
            cell.imageView.image = UIImage(named: "Placeholder avatar")!
            return cell
        }
    
        return cell
    }
}
