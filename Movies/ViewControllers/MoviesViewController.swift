//
//  ViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

import UIKit

class MoviesViewController: UICollectionViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let refreshControl = UIRefreshControl()
    
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        collectionView.refreshControl = refreshControl
        setupRefreshControl()
        downloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieID", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        
        let movie = movies[indexPath.item]
        cell.configure(movie: movie, cell: cell)
        
        self.activityIndicator.stopAnimating()
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first?.item else { return }
        
        descriptionVC.movie = movies[indexPath]
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 300)
    }
}

extension MoviesViewController {
    @objc private func downloadData() {
            NetworkManager.shared.fetchMovies(url: NetworkManager.shared.url) { result in
                switch result {
                case .success(let allMoviesDescriptions):
                    self.movies = allMoviesDescriptions.movies ?? []
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                case .failure(let error):
                    print(error)
                }
            }
        }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(downloadData), for: .valueChanged)
    }
}


