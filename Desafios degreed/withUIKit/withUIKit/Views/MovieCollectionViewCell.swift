//
//  MovieCollectionViewCell.swift
//  withUIKit
//
//  Created by Joel Tavares on 23/06/25.
//

import Foundation
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"

    let imageView = UIImageView()
    let titleLabel = UILabel()
    let detailsLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2

        detailsLabel.font = UIFont.systemFont(ofSize: 14)
        detailsLabel.textColor = .gray
        detailsLabel.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, detailsLabel])
        stack.axis = .vertical
        stack.spacing = 4
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

    func configure(with movie: Cinema.Movie) {
        titleLabel.text = movie.title

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateStr = formatter.string(from: movie.releaseDate)
        let genre = movie.genres.first?.name ?? "Unknown"
        let popularity = String(format: "%.1f", movie.popularity)

        detailsLabel.text = "\(genre) • \(dateStr) | \(popularity)"

        // Simple image load (replace with async fetch in real case)
        if let url = URL(string: movie.posterPath) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let img = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = img
                    }
                } else {
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(systemName: "photo")
                    }
                }
            }
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}
