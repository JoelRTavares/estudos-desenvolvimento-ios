//
//  MovieInfoCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import UIKit

class MovieInfoCell: UITableViewCell {
    // Backdrop image
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Movie title
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    // Rating
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .systemRed
        return label
    }()
    
    // Duration and rating
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "2Hr 10m | R"
        return label
    }()
    
    // Genres
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let ratingInfoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        return stack
    }()
    
    private let detailsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Add backdrop image
        contentView.addSubview(backdropImageView)
        backdropImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the info stack view with title and rating
        contentView.addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup nested stack views for rating info
        detailsStackView.addArrangedSubview(durationLabel)
        detailsStackView.addArrangedSubview(genresLabel)
        
        ratingInfoStackView.addArrangedSubview(ratingLabel)
        ratingInfoStackView.addArrangedSubview(detailsStackView)
        
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(ratingInfoStackView)
        
        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalTo: backdropImageView.widthAnchor, multiplier: 9/16),
            
            infoStackView.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 22),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8)
        ])
    }
    
    func configure(with movie: Cinema.Movie) {
        titleLabel.text = movie.originalTitle
        ratingLabel.text = String(format: DetailsConst.voteFormat, movie.voteAverage)
        genresLabel.text = movie.genres.map { $0.name }.joined(separator: ", ")
        
        // Load the backdrop image
        if let url = URL(string: movie.backdropPath) {
            loadImage(from: url, into: backdropImageView)
        } else {
            backdropImageView.image = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
                }
                return
            }
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
