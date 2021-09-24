//
//  Movie.swift
//  Movies
//
//  Created by Анатолий Миронов on 24.09.2021.
//

struct Movie: Decodable {
    let title: String?
    let poster: String?
}

struct AllMoviesDescriptions: Decodable {
    let movies: [Movie]?
}
