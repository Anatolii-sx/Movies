//
//  FavoriteMoviesTableViewController.swift
//  Movies
//
//  Created by Анатолий Миронов on 04.10.2021.
//

import UIKit

class FavoriteMoviesTableViewController: UITableViewController {
    
    // MARK: - Public Properties
    var films: [Film] = []
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = "Избранное"
        fetchCoreData()
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let descriptionVC = segue.destination as? DescriptionViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let film = films[indexPath.row]
        descriptionVC.film = film
        descriptionVC.isFavoriteButtonHidden = true
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        films.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let film = films[indexPath.row]
        
        // Set text
        content.text = film.title ?? ""
        
        // Set secondary text
        let genres = film.genres ?? []
        content.secondaryText = genres.joined(separator: ", ")
        
        // Set image
        StorageManager.shared.getPosterImageData(film: film) { data in
            content.image = UIImage(data: data)
            content.imageProperties.cornerRadius = 3
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: -  TableView Delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            films[indexPath.row].isFavorite.toggle()
            StorageManager.shared.saveContext()
            
            films.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Data from Core Data
extension FavoriteMoviesTableViewController {
    private func fetchCoreData() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let films):
                var favoriteMovies = films.filter {$0.isFavorite}
                favoriteMovies = favoriteMovies.sorted { $0.title ?? "" < $1.title ?? "" }
                self.films = favoriteMovies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
