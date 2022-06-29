//
//  DetailVC.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 25.06.2022.
//

import UIKit
import RxSwift

class DetailVC: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var moviePlot: UITextView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var imdbVote: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var movieDetail: MovieDetail?
    var imdbId: String?
    
    private var viewModel = DetailViewModel()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        scrollView.isHidden = true
        moviePlot.isEditable = false
        displayMovieDetail()
        // Do any additional setup after loading the view.
    }
}

extension DetailVC {
    
    private func displayMovieDetail() {
        
        guard let imdbId = imdbId else { return }
        
        return viewModel.getMovieDetail(imdbId: imdbId)
            .subscribe(onNext: { [weak self] movie in
                
                self?.movieDetail = movie
                
                DispatchQueue.main.async {
                    
                    self?.showMovieData()
                    
                    self?.configureNavBar()
                    
                    self?.activityIndicator.isHidden = true
                    self?.scrollView.isHidden = false
                    
                }
            }, onError: { error in
                print("Error observer DetailView: \(error)")
            }).disposed(by: disposeBag)
    }
    
    private func showMovieData() {
        
        guard let movie = self.movieDetail else { return }
        
        if let imageUrl = movie.image {
            movieImage.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "indiBackground"))
        }
        
        if let genre = movie.genre {
        self.genreLabel.text = genre
        }
        
        if let director = movie.director {
        self.directorLabel.text = director
        }
        
        
        if let language = movie.language {
        self.languageLabel.text = language
        }
        
        if let actors = movie.actors {
        self.actorLabel.text = actors
        }
        
        self.moviePlot.text = "\(movie.plot)"
        
        //let text = "\(movie.title) (\(movie.released.formatted(.iso8601.year())))"
        self.movieTitle.text = "\(movie.title)  (\(movie.year))"

//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWithSafari))
//        titleLabel.addGestureRecognizer(tapGesture)
//        titleLabel.isUserInteractionEnabled = true
        
        
        self.imdbVote.text = String(movie.imdbRating)
        self.releasedDate.text = String(describing: movie.released)
    }
    
//    @objc func openWithSafari() {
//        guard let movieId = movieDetail?.imdbID else { return }
//        guard let url = URL(string: "\(Constants.URL.imdbUrl)\(String(describing: movieId))") else { return }
//        let svc = SFSafariViewController(url: url)
//        present(svc, animated: true, completion: nil)
//
//    }
    
    private func configureNavBar() {
        
        guard let movie = self.movieDetail else { return }
        
        let backTitle = "\(movie.title)"
        self.navigationController?.navigationBar.backItem?.backBarButtonItem = UIBarButtonItem(title: backTitle, style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = .black
        
    }
    
   
}
