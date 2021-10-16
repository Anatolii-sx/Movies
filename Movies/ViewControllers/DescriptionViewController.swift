//
//  DescriptionViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 26.09.2021.
//

import UIKit
import SafariServices

class DescriptionViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet var posterImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var trailerButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    // MARK: - Public Properties
    var film: Film!
    var indexPath: Int!
    var delegate: DescriptionViewControllerDelegate!
    var isFavoriteButtonHidden: Bool!
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteButton.isHidden = isFavoriteButtonHidden
        
        setCornerRadiusForButtonsAndImage()
        setTextInLabels()
        fetchImage()
        addGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStartedTitleOfFavoriteButton()
    }

    // MARK: - IB Actions
    @IBAction func trailerButtonTapped() {
        showTrailer()
    }
    
    @IBAction func favoriteButtonTapped() {
        delegate.updateFavoriteStatusOfFilm(indexPath: indexPath)
        changeTitleOfFavoriteButton()
    }
    
    // MARK: - Private Methods
    private func setCornerRadiusForButtonsAndImage() {
        trailerButton.layer.cornerRadius = 7
        favoriteButton.layer.cornerRadius = 7
        posterImageView.layer.cornerRadius = 7
    }
    
    private func setTextInLabels() {
        titleLabel.text = film.title ?? ""
        yearLabel.text = "Год:  \(film.year)"
        ratingLabel.text = "Рейтинг:  \(film.ratingKinopoisk ?? "")"
        descriptionLabel.text = "Описание:  \(film.descriptionOfMovie ?? "")"
        
        let genres = film.genres ?? []
        genreLabel.text = "Жанр:  \(genres.joined(separator: ", "))"
    }
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.gestureFired))
        gestureRecognizer.direction = .right
        gestureRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(gestureRecognizer)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func gestureFired(sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setStartedTitleOfFavoriteButton() {
        film.isFavorite
            ? favoriteButton.setTitle("  ⛔️ Из избранного", for: .normal)
            : favoriteButton.setTitle("  ⭐️ В избранное", for: .normal)
    }
    
    private func changeTitleOfFavoriteButton() {
        if film.isFavorite {
            showAlert(title: "✅", message: "Фильм удалён из избранных")
            favoriteButton.setTitle("  ⭐️ В избранное", for: .normal)
        } else {
            showAlert(title: "✅", message: "Фильм добавлен в избранные")
            favoriteButton.setTitle("  ⛔️ Из избранного", for: .normal)
        }
        film.isFavorite.toggle()
        StorageManager.shared.saveContext()
    }
    
    private func showTrailer() {
        guard let trailer = film.trailer else {
            showAlert(title: "Ошибка", message: "К сожалению, видео отсутствует 😔")
            return
        }
        guard let trailerURL = URL(string: trailer) else { return }
        let safariViewController = SFSafariViewController(url: trailerURL)
        present(safariViewController, animated: true)
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

// MARK: - Image from Core Data
extension DescriptionViewController {
    func fetchImage() {
        StorageManager.shared.getPosterImageData(film: film) { data in
            self.posterImageView.image = UIImage(data: data)
        }
    }
}
