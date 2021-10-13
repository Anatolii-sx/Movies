//
//  Movie.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

import Foundation

struct Movie: Codable {
    let title: String?
    let poster: String?
    let ratingKinopoisk: String?
    let year: Int?
    let description: String?
    let genres: [String]?
    let trailer: String?
    var isFavorite: Bool?
}

struct AllMoviesDescriptions: Decodable {
    let movies: [Movie]?
}
