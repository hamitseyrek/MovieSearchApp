//
//  MovieCell.swift
//  MovieChallenge
//
//  Created by Hamit Seyrek on 24.06.2022.
//

import UIKit
import Kingfisher
import RxSwift

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var viewModel = DetailViewModel()
    private var disposeBag = DisposeBag()
    
    var movie: Movie? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension MovieCell {
    
    private func configureCell() {
        
        activityIndicator.isHidden = false
        guard let movie = self.movie else { return }
        
        if let imageUrl = movie.image {
            movieImage.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: "indiBackground"))
        }
        
        getOverview(imdbId: movie.imdbId)
        title.text = movie.title
    }
    
    func getOverview(imdbId: String) {
        
        viewModel.getMovieDetail(imdbId: imdbId)
        
            .subscribe(onNext: { [weak self] movie in
                
                DispatchQueue.main.async {
                    self?.overViewLabel.text = movie.plot
                    self?.dateLabel.text = movie.released
                    self?.activityIndicator.isHidden = true
                }
                
            }, onError: { error in
                print("Error observer DetailVC: \(error)")
                
            }).disposed(by: disposeBag)
    }
}
