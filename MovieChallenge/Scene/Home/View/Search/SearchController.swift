//
//  SearchController.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import UIKit

class SearchController: UISearchController {
  init() {
    super.init(searchResultsController: nil)
    configureSearchController()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SearchController {
  func configureSearchController() {
    hidesNavigationBarDuringPresentation = true
//    obscuresBackgroundDuringPresentation = true
    searchBar.sizeToFit()
    searchBar.barStyle = .default
    searchBar.backgroundColor = UIColor.clear
    searchBar.placeholder = "Ara..."
  }
}

