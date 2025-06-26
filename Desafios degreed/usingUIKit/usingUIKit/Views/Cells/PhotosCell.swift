//
//  PhotosCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import UIKit

class PhotosCell: UITableViewCell {
    private lazy var scrollView = UIScrollViewFactory.createHorizontalScrollView()
    private lazy var stackView = UIStackViewFactory.createHorizontalStackView()
    
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
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            scrollView.heightAnchor.constraint(equalToConstant: 180),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    func configure(with photos: [String]) {
        // Clear existing images
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for photo in photos {
            let photoView = UIImageViewFactory.createAspectFillImageView(cornerRadius: DetailsConst.Img.cornerRadius)
            
            photoView.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = photoView.heightAnchor.constraint(equalToConstant: 120)
            let widthConstraint = photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor, multiplier: DetailsConst.Img.aspectRatio)
            NSLayoutConstraint.activate([heightConstraint, widthConstraint])
            
            stackView.addArrangedSubview(photoView)
            
            if let url = URL(string: photo) {
                loadImage(from: url, into: photoView)
            } else {
                photoView.image = UIImage(systemName: DetailsConst.Img.defaultImgNotFound)
            }
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
