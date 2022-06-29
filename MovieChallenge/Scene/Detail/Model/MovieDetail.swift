//
//  MovieDetail.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import Foundation

struct MovieDetail: Decodable {
    
    let imdbId: String
    let title: String
    let year: String
    let plot: String
    let runtime: String?
    let imdbRating: String
    let genre: String?
    let released: String
    let image: String?
    let actors: String?
    let director: String?
    let language: String?
    
    enum CodingKeys: String, CodingKey {
        case imdbId = "imdbID"
        case title = "Title"
        case year = "Year"
        case plot = "Plot"
        case runtime = "Runtime"
        case imdbRating = "imdbRating"
        case genre = "Genre"
        case released = "Released"
        case image = "Poster"
        case actors = "Actors"
        case director = "Director"
        case language = "Language"
    }
}
