//
//  NetworkError.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import Foundation

enum NetworkError: String, Error {
    
    case apiError = "Failed to fetch data"
    case invalidEndpoint = "Invalid endpoint"
    case serializationError = "Failed to decode data"

}
