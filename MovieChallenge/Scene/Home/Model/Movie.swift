//
//  Movie.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import Foundation

struct Movies: Decodable {
    let moviesList: [Movie]?
    let response: String
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case moviesList = "Search"
        case response = "Response"
        case error = "Error"
    }
    
}

struct Movie: Decodable {
    let imdbId: String
    let title: String
    let year: String
    let type: String
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case imdbId = "imdbID"
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case image = "Poster"
    }
}
