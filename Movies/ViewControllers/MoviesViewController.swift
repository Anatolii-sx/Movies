//
//  ViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet var posterImage: UIImageView!
    
    @IBOutlet weak var ratingStackView: UIStackView!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
}

class MoviesViewController: UICollectionViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    private var movies: [Movie] = []
    
    private let token = "ef8a6db59d96795f64bc1d073ac9e585"
    
    private var url: String {
        "https://api.kinopoisk.cloud/movies/all/page/7/token/\(token)"
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
        
        cell.layer.cornerRadius = 12
        cell.titleLabel.layer.cornerRadius = 12
        cell.posterImage.layer.cornerRadius = 12
        
        cell.ratingStackView.layer.cornerRadius = 5
        
        cell.layer.shadowRadius = 6
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: -3, height: -3)
        
        DispatchQueue.main.async {
            cell.titleLabel.text = "\(self.movies[indexPath.item].title ?? "")"
            
            cell.ratingLabel.text = "\(self.movies[indexPath.item].rating_kinopoisk ?? "")"
        }
        
        DispatchQueue.global().async {
            let https = "https:"
            
            guard let url = URL(string: https + (self.movies[indexPath.item].poster ?? "")) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                cell.posterImage.image = UIImage(data: imageData)
                self.activityIndicator.stopAnimating()
            }
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first?.item else { return }
        
        descriptionVC.movie = movies[indexPath]
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


