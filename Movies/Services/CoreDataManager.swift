//
//  CoreDataManager.swift
//  Movies
//
//  Created by Анатолий Миронов on 12.10.2021.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // MARK: - Core Data stack
    // "Вход" в БД
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Создание viewContext (все изменения данных фиксируются в оперативной памяти)
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Public Methods
    // Получение данных (массива [Film])
    func fetchData(completion: (Result<[Film], Error>) -> Void) {
        let fetchRequest = Film.fetchRequest()

        do {
            let films = try viewContext.fetch(fetchRequest)
            completion(.success(films))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    // Сохранение данных. Сохраняемая новая задача и возвращаемое значение в completion для передачи в массив во вью
    func save(movies: [Movie]) {
        for movie in movies {
            // Создание экземпляра модели данных из БД
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Film", in: viewContext) else { return }
            guard let film = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Film else { return }
            
            film.title = movie.title
            film.poster = movie.poster
            film.ratingKinopoisk = movie.ratingKinopoisk
            film.year = Int64(movie.year ?? 0)
            film.descriptionOfMovie = movie.description
            film.genres = movie.genres
            film.trailer = movie.trailer
            
        }
        saveContext()
    }

    // Удаление фильмов из контекста и сохранение изменений в базе
    func deleteAllFilms() {
        fetchData { result in
            switch result {
            case .success(let films):
                films.forEach { viewContext.delete($0) }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    // Если есть изменения в viewContext, то сохранить в базе
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
