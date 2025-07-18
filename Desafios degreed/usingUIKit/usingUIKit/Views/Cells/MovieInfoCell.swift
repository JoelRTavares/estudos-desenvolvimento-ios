//
//  MovieInfoCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import UIKit

class MovieInfoCell: UITableViewCell {
    let viewModel = CinemaRealmViewModel()
    var movie: Cinema.Movie?
    
    private lazy var backdropImageView = UIImageViewFactory.createAspectFillImageView()
    private lazy var titleLabel = UILabelFactory.createTitleLabel(accessibleIdentifier: "MovieTitleLabel")
    private lazy var addFavoriteButton = UIButtonFactory.createButton(title: "ADD Favorite")
    private lazy var titleHStackView = UIStackViewFactory.createHorizontalStackView()
    
    private lazy var ratingLabel = UILabelFactory.createRatingLabel()
    private lazy var durationLabel = UILabelFactory.createLabel(text: "2Hr 10m | R", fontSize: 18)
    private lazy var genresLabel = UILabelFactory.createLabel(fontSize: 18)
    
    private lazy var infoStackView = UIStackViewFactory.createVerticalStackView()
    private lazy var ratingInfoStackView = UIStackViewFactory.createHorizontalStackView()
    private lazy var detailsStackView = UIStackViewFactory.createVerticalStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //print(viewModel.fetchAllMovies())
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(backdropImageView)
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        detailsStackView.addArrangedSubview(durationLabel)
        detailsStackView.addArrangedSubview(genresLabel)
        
        ratingInfoStackView.addArrangedSubview(ratingLabel)
        ratingInfoStackView.addArrangedSubview(detailsStackView)
        
        
        addFavoriteButton.setTitleColor(.reverseBackground, for: .normal)
        addFavoriteButton.addTarget(self, action: #selector(callAddMovieRealm), for: .touchUpInside)
        
        titleHStackView.addArrangedSubview(titleLabel)
        titleHStackView.addArrangedSubview(addFavoriteButton)
        titleHStackView.distribution = .fillEqually
        infoStackView.addArrangedSubview(titleHStackView)
        infoStackView.addArrangedSubview(ratingInfoStackView)
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 9/16),
            
            infoStackView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 22),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func callAddMovieRealm(){
        if let movie = movie{
            let movie = MovieRealm(id: movie.id, name: movie.title, releaseDate: movie.releaseDate.toFormat("yyyy-MM-dd"), rating: movie.popularity, firstGenre: movie.genres[0].name, posterPath: movie.posterPath)
            viewModel.writeNewMovie(movie)
        }
    }
    
    func configure(with movie: Cinema.Movie) {
        titleLabel.text = movie.originalTitle
        self.movie = movie
        ratingLabel.text = String(format: DetailsConst.voteFormat, movie.voteAverage)
        genresLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        
        if let url = URL(string: movie.backdropPath) {
            ImageUtils.loadImage(from: url, into: backdropImageView)
        } else {
            backdropImageView.image = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
        }
    }
}
