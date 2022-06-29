//
//  DetailViewModel.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 26.06.2022.
//

import Foundation
import RxSwift

class DetailViewModel {
    
    private let apiService = ApiService()
    
    func getMovieDetail(imdbId: String) -> Observable<MovieDetail> {
        return apiService.getMovieDetail(imdbId: imdbId)
    }
}
