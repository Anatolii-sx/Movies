//
//  NetworkManager.swift
//  Movies
//
//  Created by Анатолий Миронов on 26.09.2021.
//

import Foundation

// You can use 1 token for only 10 free requests a day
enum Token: String {
    case tokenOne = "e705ff8540b59c221121b4537efc361d"
    case tokenTwo = "f9b1c2c02f9919bf405d41f2cd177bf9"
    case tokenThree = "a529e5de7df6ad85fdafb3a8d85cbb63"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    var url: String {
        "https://cloud-api.kinopoisk.dev/movies/all/page/\(Int.random(in: 1...500))/token/\(Token.tokenOne.rawValue)"
    }
    
    private init() {}
    
    func fetchMovies(url: String, completion: @escaping (Result<AllMoviesDescriptions, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error with taking data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let allMoviesDescriptions = try decoder.decode(AllMoviesDescriptions.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(allMoviesDescriptions))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

