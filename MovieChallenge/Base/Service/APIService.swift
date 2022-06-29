//
//  APIService.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import Foundation
import RxSwift

class ApiService {
    
    func searchResult(searchKey: String?) -> Observable<[Movie]> {
        
        let path = "\(Constants.omdbUrl.rawValue)?s=\(searchKey!)&apiKey=\(Constants.key.rawValue)"
        
        return Observable.create { observer in
            
            NetworkRequest.networkRequest(path: path) { (completion: Result<Movies, NetworkError>) in
                
                switch completion {
                    
                case .success(data: let data):
                    guard let moviesList = data.moviesList else {
                        return observer.onError(NetworkError.apiError)
                    }
                    observer.onNext(moviesList)
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getMovieDetail(imdbId: String?) -> Observable<MovieDetail> {
        
        let path = "\(Constants.omdbUrl.rawValue)?i=\(imdbId!)&apiKey=\(Constants.key.rawValue)"

        return Observable.create { observer in
            
            NetworkRequest.networkRequest(path: path) { (completion: Result<MovieDetail, NetworkError>) in
                
                switch completion {
                    
                case .success(data: let data):
                    observer.onNext(data)
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
