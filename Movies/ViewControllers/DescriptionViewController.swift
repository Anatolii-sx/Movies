//
//  DescriptionViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 26.09.2021.
//

import UIKit

class DescriptionViewController: UIViewController {

    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie.title
        yearLabel.text = "Год:   \(movie.year ?? 0)"
        
        ratingLabel.text = "Рейтинг:   \(movie.rating_kinopoisk ?? "")"
        
        let genres = movie.genres ?? []
        genreLabel.text = "Жанр:   \(genres.joined(separator: ", "))"
        
        descriptionLabel.text = "Описание:   \(movie.description ?? "")"
    }
}

extension DescriptionViewController {
    func fetchImage() {
        
        DispatchQueue.global().async {
            let https = "https:"
            
            guard let url = URL(string: https + (self.movie.poster ?? "")) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: imageData)
                //self.activityIndicator.stopAnimating()
                self.view.reloadInputViews()
            }
        }
    }
}


