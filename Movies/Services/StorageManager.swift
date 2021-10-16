//
//  StorageManager.swift
//  Movies
//
//  Created by Анатолий Миронов on 12.10.2021.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    func fetchData(completion: (Result<[Film], Error>) -> Void) {
        let fetchRequest = Film.fetchRequest()

        do {
            let films = try viewContext.fetch(fetchRequest)
            completion(.success(films))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Save data from Network Manager
    func save(movies: [Movie]) {
        for movie in movies {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Film", in: viewContext) else { return }
            guard let film = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Film else { return }
            
            film.title = movie.title ?? ""
            film.poster = movie.poster ?? ""
            film.ratingKinopoisk = movie.ratingKinopoisk ?? ""
            film.year = Int64(movie.year ?? 0)
            film.descriptionOfMovie = movie.description ?? ""
            film.genres = movie.genres ?? []
            film.trailer = movie.trailer ?? ""
            film.isFavorite = false
            film.posterImageData = nil

            saveContext()
        }
    }

    // If we don't have the Internet
    func getPosterImageData(movie: Film, completion: (Data) -> Void) {
        guard let posterImageData = movie.posterImageData else { return }
        completion(posterImageData)
    }
    
    // If we have the Internet
    func savePosterImageData(movie: Film, imageData: Data) {
        movie.posterImageData = imageData
    }
    
    func deleteAllFilmsExceptFavorites() {
        fetchData { result in
            switch result {
            case .success(let films):
                films.forEach { film in
                    if film.isFavorite == false {
                        viewContext.delete(film)
                    }
                }
                saveContext()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
