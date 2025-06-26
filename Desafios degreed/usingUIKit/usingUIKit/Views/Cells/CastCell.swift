//
//  CastCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import UIKit

class CastCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = DetailsConst.Img.circleSize / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "•••"
        label.textAlignment = .center
        return label
    }()
    
    private let roleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
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
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nameLabel)
        
        // Add spacer
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(spacerView)
        
        stackView.addArrangedSubview(separatorLabel)
        
        // Add another spacer
        let spacerView2 = UIView()
        spacerView2.setContentHuggingPriority(.defaultLow, for: .horizontal)
        stackView.addArrangedSubview(spacerView2)
        
        stackView.addArrangedSubview(roleLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: DetailsConst.Img.circleSize),
            profileImageView.heightAnchor.constraint(equalToConstant: DetailsConst.Img.circleSize),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with actor: Cinema.Movie.Actor) {
        nameLabel.text = actor.name
        roleLabel.text = actor.character
        
        if let profilePath = actor.profile_path, let url = URL(string: profilePath) {
            loadImage(from: url, into: profileImageView)
        } else {
            profileImageView.image = UIImage(systemName: DetailsConst.Img.defaultImgNotExists)
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
