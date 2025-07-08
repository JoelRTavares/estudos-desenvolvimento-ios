//
//  MovieRealmCollectionViewCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 08/07/25.
//


import Foundation
import UIKit

class MovieRealmCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieRealmCollectionViewCell"

    let imageView = UIImageView()
    let titleLabel = UILabel()
    let detailsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .background
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)

        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.textColor = .gray

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, detailsLabel])
        stack.axis = .vertical
        
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 5.0/3.0)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: MovieRealm) {
        titleLabel.text = movie.name

        let dateStr = movie.releaseDate
        let genre = movie.firstGenre
        let popularity = String(format: "%.1f", movie.rating)

        detailsLabel.text = "\(genre) • \(dateStr) | \(popularity)"
        detailsLabel.font = UIFont.systemFont(ofSize: 12)
        
        
        if let url = URL(string: movie.posterPath) {
            ImageUtils.loadImage(from: url, into: self.imageView)
            
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
    
    
}
