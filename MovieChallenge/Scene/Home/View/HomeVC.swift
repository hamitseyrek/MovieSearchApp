//
//  HomeVC.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 24.06.2022.
//

import UIKit
import RxCocoa
import RxSwift

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    private var movies = [Movie]()
    
    lazy var searchController = SearchController()
    
    private var lastSearch: String?
    private var lastSearches = [String]()
    
    var headerLabel = UILabel()
    var container = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
    }
}

extension HomeVC {
    
    private func configureVC() {
        
        configureNavBar()
        configureTableView()
        configureSearchController()
        configureTableViewHeader()
    }
    
    private func configureNavBar() {
        navigationItem.title = "Film Arama Uygulaması"
    }
    
    private func configureTableViewHeader() {
        
        container = UIView(frame: CGRect(x: 2, y: 0, width: 300, height: 50))
        
        headerLabel.text = "Henüz hiç arama yapılmadı..."
        headerLabel.textColor = .black
        headerLabel.font = .boldSystemFont(ofSize: 17)
        headerLabel.frame = container.frame
        container.addSubview(headerLabel)
        
        DispatchQueue.main.async {
            let headerView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: self.tableView.frame.width,
                                                  height: 50))
            headerView.backgroundColor = .white
            headerView.addSubview(self.container)
            self.tableView.tableHeaderView = headerView
        }
    }
    
    private func configureTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MovieCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        
    }
    
    private func configureSearchController() {
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        navigationItem.searchController = searchController
        
        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                strongSelf.viewModel.searchResult(searchKey: result)
                
                    .subscribe(on: MainScheduler.instance)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        
                        onNext: { [weak self] movies in
                            
                            self?.movies = movies
                            self?.updateTableView()
                            
                            if !result.isEmpty {
                                self?.lastSearch = result
                            }
                            
                        }, onError: { error in
                            
                            self?.movies = []
                            self?.updateTableView()
                            print("error in view: \((error as! NetworkError).rawValue)")
                            
                        }, onCompleted: {}).disposed(by: strongSelf.disposeBag)
                
            }).disposed(by: disposeBag)
    }
    
    private func updateTableView() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.tableView.reloadData()
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = true
        }
    }
}

extension HomeVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchController.isActive = false
        
        tableView.register(UINib(nibName: "LastSearchCell", bundle: Bundle.main), forCellReuseIdentifier: "SearchCell")
        
        if let search = lastSearch {
            
            if lastSearches.last != search {
                lastSearches.append(search)
            }
        }
        
        tableView.reloadData()
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchController.isActive || searchController.searchBar.text != "" {
            headerLabel.text = "Arama Sonuçları"
            return 136
        } else {
            headerLabel.text = "Son Aramalar"
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive || searchController.searchBar.text != "" {
            return movies.count
        } else {
            return lastSearches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !searchController.isActive || searchController.searchBar.text == "" {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? LastSearchCell else {
                fatalError("Error dequing cell: SearchCell")
            }
            
            lastSearches = lastSearches.reversed()
            cell.searchLabel.text = lastSearches[indexPath.row]
            lastSearches = lastSearches.reversed()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MovieCell else {
                fatalError("Error dequing cell: Cell")
            }
            
            let movie = movies[indexPath.row]
            cell.movie = movie
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive || searchController.searchBar.text != "" {
            let movie = movies[indexPath.row]
            
            let vc = DetailVC(nibName: "DetailVC", bundle: Bundle.main)
            vc.imdbId = movie.imdbId
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if !lastSearches.isEmpty {
                
                lastSearches = lastSearches.reversed()
                self.viewModel.searchResult(searchKey: lastSearches[indexPath.row])
                
                    .subscribe(on: MainScheduler.instance)
                    .observe(on: MainScheduler.instance)
                    .subscribe(
                        
                        onNext: { [weak self] movies in
                            
                            self?.movies = movies
                            self?.updateTableView()
                            
                            self?.searchController.isActive = true
                            self?.searchController.searchBar.text = self?.lastSearches[indexPath.row]
                            
                        }, onError: { error in
                            
                            self.movies = []
                            self.updateTableView()
                            print("error in view: \((error as! NetworkError).rawValue)")
                            
                        }, onCompleted: {}).disposed(by: self.disposeBag)
                lastSearches = lastSearches.reversed()
            }
        }
    }
}
