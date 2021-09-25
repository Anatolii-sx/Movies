//
//  Movie.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

struct Movie: Decodable {
    let title: String?
    let poster: String?
    let rating_kinopoisk: String?
    let year: Int?
    let description: String?
    let genres: [String]?
}

struct AllMoviesDescriptions: Decodable {
    let movies: [Movie]?
}
