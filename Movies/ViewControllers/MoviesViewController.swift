//
//  ViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

import UIKit

protocol DescriptionViewControllerDelegate {
    func updateFavoriteStatusOfFilm(indexPath: Int)
}

class MoviesViewController: UICollectionViewController {
    
    // MARK: - IB Outlets
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private let refreshControl = UIRefreshControl()
    private var films: [Film] = []
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        setupRefreshControl()
        downloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Фильмы"
        refreshControl.endRefreshing()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        films.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieID", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        let film = films[indexPath.item]
        cell.configure(film: film, cell: cell)
        self.activityIndicator.stopAnimating()
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first?.item else { return }
        
        descriptionVC.film = films[indexPath]
        descriptionVC.isFavoriteButtonHidden = false
        descriptionVC.indexPath = indexPath
        descriptionVC.delegate = self
    }
}

// MARK: - Collection View Item Size
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 300)
    }
}

// MARK: - Refresh Controll
extension MoviesViewController {
    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(downloadData), for: .valueChanged)
    }
}

// MARK: - Description View Controller Delegate
extension MoviesViewController: DescriptionViewControllerDelegate {
    func updateFavoriteStatusOfFilm(indexPath: Int) {
        let number = IndexPath(item: indexPath, section: 0)
        collectionView.reloadItems(at: [number])
    }
}

// MARK: - Data from Network Manager
extension MoviesViewController {
    @objc private func downloadData() {
        NetworkManager.shared.fetchMovies(url: NetworkManager.shared.url) { result in
            switch result {
            case .success(let allMoviesDescriptions):
                let downloadedMovies = allMoviesDescriptions.movies ?? []
                self.films = []
                
                StorageManager.shared.deleteAllFilmsExceptFavorites()
                StorageManager.shared.save(movies: downloadedMovies)
                self.fetchCoreData()
                
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            case .failure(let error):
                self.films = []
                self.fetchCoreData()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                print(error)
            }
        }
    }
}

// MARK: - Data from Core Data
extension MoviesViewController {
    private func fetchCoreData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let films):
                let unfavoriteMovies = films.filter {!$0.isFavorite}
                self.films = unfavoriteMovies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}




