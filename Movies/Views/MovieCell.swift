//
//  MovieCellCollectionViewCell.swift
//  Movies
//
//  Created by Анатолий Миронов on 26.09.2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet var posterImage: UIImageView!
    
    @IBOutlet var ratingStackView: UIStackView!

    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    func configure(movie: Movie, cell: UICollectionViewCell) {
        
        cell.layer.cornerRadius = 20
        cell.layer.shadowRadius = 6
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: -2, height: -2)
        
        titleLabel.layer.cornerRadius = 20
        posterImage.layer.cornerRadius = 20
        ratingStackView.layer.cornerRadius = 5
        
        DispatchQueue.main.async {
            self.titleLabel.text = "\(movie.title ?? "")"
            let rating = movie.ratingKinopoisk ?? ""
            let ratingDouble = Double(rating)
            let ratingAround = String(format: "%.01f", ratingDouble ?? 0)
            self.ratingLabel.text = ratingAround
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https:\(movie.poster ?? "")") else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                self.posterImage.image = UIImage(data: imageData)
            }
        }
    }
}
