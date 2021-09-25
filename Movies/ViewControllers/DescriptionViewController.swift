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
        
//        posterImageView.image = UIImage(data: movie.poster)
        
        titleLabel.text = movie.title
        yearLabel.text = "Год:   \(movie.year ?? 0)"
        ratingLabel.text = "Рейтинг:   \(movie.rating_kinopoisk ?? "")"
        genreLabel.text = "Жанр:   \(movie.genres ?? [])"
        descriptionLabel.text = "Описание:   \(movie.description ?? "")"
        
    }
}
