//
//  NetworkRequest.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import Foundation
import Alamofire
import SwiftUI

enum NetworkRequest {
    
    static func networkRequest<T: Decodable>(path: String, completion: @escaping (Result<T,NetworkError>) -> Void) {
        
        AF.request(path)
          .validate()
          .responseDecodable(of: T.self) { (response) in
              
              guard response.error == nil else { return completion(.failure(.invalidEndpoint)) }
              guard let movies = response.value else { return completion(.failure(.serializationError)) }
              return completion(.success(movies))
          }
    }
}
