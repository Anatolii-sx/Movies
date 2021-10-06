//
//  StorageManager.swift
//  Movies
//
//  Created by Анатолий Миронов on 06.10.2021.
//

import  Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "movies"
    
    private init() {}
    
    func save(movie: Movie) {
        var movies = fetchMovies()
        movies.append(movie)
        guard let data = try? JSONEncoder().encode(movies) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func fetchMovies() -> [Movie] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let movies = try? JSONDecoder().decode([Movie].self, from: data) else { return [] }
        return movies
    }
    
    func deleteMovie(at index: Int) {
        var movies = fetchMovies()
        movies.remove(at: index)
        guard let data = try? JSONEncoder().encode(movies) else { return }
        userDefaults.set(data, forKey: key)
    }
}
