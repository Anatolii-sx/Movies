//
//  DescriptionViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 26.09.2021.
//

import UIKit
import SafariServices

class DescriptionViewController: UIViewController {

    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var trailerButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var movie: Movie!
    var visibilityOfFavoriteButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trailerButton.layer.cornerRadius = 12
        favoriteButton.layer.cornerRadius = 12
        
        favoriteButton.isHidden = visibilityOfFavoriteButton
        
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureFired))
        gestureRecognizer.direction = .right
        gestureRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gestureRecognizer)
        view.isUserInteractionEnabled = true
        
        fetchImage()
        
        titleLabel.text = movie.title ?? ""
        yearLabel.text = "Год:  \(movie.year ?? 0)"
        ratingLabel.text = "Рейтинг:  \(movie.ratingKinopoisk ?? "")"
        descriptionLabel.text = "Описание:  \(movie.description ?? "")"
        
        let genres = movie.genres ?? []
        genreLabel.text = "Жанр:  \(genres.joined(separator: ", "))"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let favoriteVC = segue.destination as? FavoriteMoviesTableViewController else { return }
        guard let movie = movie else { return }
        favoriteVC.movies.append(movie)
    }
    
    @IBAction func trailerButtonTapped() {
        guard let trailer = movie.trailer else {
            showAlert(title: "Ошибка", message: "К сожалению, видео отсутствует 😔")
            return
        }
        guard let trailerURL = URL(string: trailer) else { return }
        
        let safariViewController = SFSafariViewController(url: trailerURL)
        present(safariViewController, animated: true)
    }
    
    @IBAction func favoriteButtonTapped() {
        showAlert(title: "✅", message: "Фильм добавлен в избранные")
    }
    
    @objc func gestureFired(sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        present(alert, animated: true)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
    }
}

extension DescriptionViewController {
    func fetchImage() {
        DispatchQueue.global().async {
            guard let url = URL(string: "https:\(self.movie.poster ?? "")") else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: imageData)
            }
        }
    }
}


