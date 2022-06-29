//
//  HomeViewModel.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import Foundation
import RxSwift

class HomeViewModel {
    
    private let apiService = ApiService()
    
    func searchResult(searchKey: String?) -> Observable<[Movie]> {
        return apiService.searchResult(searchKey: searchKey)
    }
}
