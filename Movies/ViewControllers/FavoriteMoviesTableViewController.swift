//
//  FavoriteMoviesTableViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 04.10.2021.
//

import UIKit

class FavoriteMoviesTableViewController: UITableViewController {
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreData()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let movie = movies[indexPath.row]
        descriptionVC.movie = movie
        descriptionVC.visibilityOfFavoriteButton = true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let movie = movies[indexPath.row]
        
        content.text = movie.title ?? ""
        
        let genres = movie.genres ?? []
        content.secondaryText = genres.joined(separator: ", ")
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https:\(movie.poster ?? "")") else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }
            DispatchQueue.main.async {
                content.image = UIImage(data: imageData)
                content.imageProperties.cornerRadius = 3
                cell.contentConfiguration = content
            }
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: -  TableView Delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteFromFavorites(favoriteMovie: movies[indexPath.row])
            movies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension FavoriteMoviesTableViewController {
    private func fetchCoreData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let films):
                movies = []
                for film in films {
                    if film.isFavorite {
                        movies.append(
                            Movie(
                                title: film.title,
                                poster: film.poster,
                                ratingKinopoisk: film.ratingKinopoisk,
                                year: Int(film.year),
                                description: film.descriptionOfMovie,
                                genres: film.genres,
                                trailer: film.trailer,
                                isFavorite: film.isFavorite
                            )
                        )
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


