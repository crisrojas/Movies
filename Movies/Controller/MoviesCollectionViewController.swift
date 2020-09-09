//
//  MoviesCollectionViewController.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import Kingfisher
import UIKit

private let reuseIdentifier = "MoviesCell"

final class MoviesCollectionViewController: UICollectionViewController {
    
    var model = Movies(results: [Movie]())
    var moviesManager = MoviesManager()
    
    private let itemsPerRow : CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesManager.delegate = self
        moviesManager.fetchMovies()
        
    }

}

// MARK: MoviesManagerDelegate

extension MoviesCollectionViewController: MoviesManagerDelegate {
    
    func didDownloadMovies(movies: Movies) {
        model = movies
        collectionView.reloadData()
    }
}

// MARK: UICollectionViewDataSource

extension MoviesCollectionViewController {
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return model.results.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ///todo: Return cell as MovieCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCell
    
        guard let urlString = self.model.results[indexPath.row].poster else { return cell }
        let url = URL(string: urlString)
        cell.imageView.kf.setImage(with: url)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MoviesDetailViewController") as? MoviesDetailViewController
        vc?.movie = self.model.results[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    /// Sets the layout size for a given cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
}
