//
//  MovieCellCollectionViewCell.swift
//  Movies
//
//  Created by Анатолий Миронов on 26.09.2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    // MARK: - IB Outlets
    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet var ratingStackView: UIStackView!

    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Public Method
    func configure(film: Film, cell: UICollectionViewCell) {
        
        cell.layer.cornerRadius = 20
        cell.layer.shadowRadius = 6
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: -2, height: -2)
        
        titleLabel.layer.cornerRadius = 20
        posterImage.layer.cornerRadius = 20
        ratingStackView.layer.cornerRadius = 5
        
        titleLabel.text = "\(film.title ?? "")"
        
        let rating = film.ratingKinopoisk ?? ""
        let ratingDouble = Double(rating)
        let ratingAround = String(format: "%.01f", ratingDouble ?? 0)
        ratingLabel.text = ratingAround
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https:\(film.poster ?? "")") else { return }
            if let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.posterImage.image = UIImage(data: imageData)
                    StorageManager.shared.savePosterImageData(film: film, imageData: imageData)
                }
            } else {
                StorageManager.shared.getPosterImageData(film: film) { data in
                    DispatchQueue.main.async {
                        self.posterImage.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
