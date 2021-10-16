//
//  MovieCellCollectionViewCell.swift
//  Movies
//
//  Created by Анатолий Миронов on 26.09.2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    // MARK: - IB Outlets
    @IBOutlet var posterImage: UIImageView!
    
    @IBOutlet var ratingStackView: UIStackView!

    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Public Method
    func configure(movie: Film, cell: UICollectionViewCell) {
        
        cell.layer.cornerRadius = 20
        cell.layer.shadowRadius = 6
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: -2, height: -2)
        
        titleLabel.layer.cornerRadius = 20
        posterImage.layer.cornerRadius = 20
        ratingStackView.layer.cornerRadius = 5
        
        titleLabel.text = "\(movie.title ?? "")"
        
        let rating = movie.ratingKinopoisk ?? ""
        let ratingDouble = Double(rating)
        let ratingAround = String(format: "%.01f", ratingDouble ?? 0)
        ratingLabel.text = ratingAround
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https:\(movie.poster ?? "")") else { return }
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(data: imageData)
                    StorageManager.shared.savePosterImageData(movie: movie, imageData: imageData)
                }
            } else {
                StorageManager.shared.getPosterImageData(movie: movie) { data in
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
