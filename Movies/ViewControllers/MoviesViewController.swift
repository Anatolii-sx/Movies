//
//  ViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

import UIKit

class MoviesViewController: UICollectionViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private var movies: [Movie] = []
    
    private let token = "fc2212f98d7bd2e7e8ef7e6aa70e482e"
    
    private var url: String {
        "https://api.kinopoisk.cloud/movies/all/page/9/token/\(token)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchData()
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
        descriptionVC.fetchImage()
    }
}

extension MoviesViewController {
    private func fetchData() {
        guard let url = URL(string: self.url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error with taking data")
                return
            }
            
            do {
                let allMoviesDescriptions = try JSONDecoder().decode(AllMoviesDescriptions.self, from: data)
                self.movies = allMoviesDescriptions.movies ?? []
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 300)
    }
}


