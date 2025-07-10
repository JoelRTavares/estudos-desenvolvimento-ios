//
//  MovieRealmCollectionViewCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 08/07/25.
//


import Foundation
import UIKit

protocol FavoriteChangeScreenDelegate {
    func pushNavigationScreen(_ screen : UIViewController)
}



class MovieRealmCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieRealmCollectionViewCell"
    let viewModel = CinemaRealmViewModel()
    var movie: MovieRealm?
    

    let imageView = UIImageViewFactory.createAspectFitImageView()
    let titleLabel = UILabelFactory.createLabel(fontSize: 16, weight: .bold)
    let detailsLabel = UILabelFactory.createLabel(fontSize: 14)
    
    var delegate : FavoriteChangeScreenDelegate?
    var updateDelegate: UpdateMovieListDelegate?

    lazy var editDeleteButtons: UIStackView = {
        let editButton = UIButtonFactory.createButton(title: "✎")
        let deleteButton = UIButtonFactory.createButton(title: "🗑️")
        
        editButton.addTarget(self, action: #selector(goToUpdateMovie), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteCurrentMovie), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [editButton, deleteButton])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .background
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        detailsLabel.textColor = .gray

        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, detailsLabel, editDeleteButtons])
        stack.axis = .vertical
        
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 5.0/3.0),
            editDeleteButtons.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: MovieRealm) {
        titleLabel.text = movie.name
        self.movie = movie
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
    
    @objc func goToUpdateMovie() {
        let editVC = SelectedFavoriteViewController()
        editVC.movie = self.movie
        editVC.delegate = updateDelegate
        delegate?.pushNavigationScreen(editVC)
    }
    
    @objc func deleteCurrentMovie(){
        if let movieToDelete = movie{
            viewModel.deleteNewMovie(movieToDelete)
        }
    }
    
}
