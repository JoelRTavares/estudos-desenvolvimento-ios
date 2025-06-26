//
//  CastCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import UIKit

class CastCell: UITableViewCell {
    
    private lazy var profileImageView = UIImageViewFactory.createCircleImageView(size: DetailsConst.Img.circleSize)
    private lazy var nameLabel = UILabelFactory.createLabel(fontSize: 18, weight: .bold)
    private lazy var separatorLabel = UILabelFactory.createLabel(text: "•••", alignment: .center)
    private lazy var roleLabel = UILabelFactory.createLabel(fontSize: 18)
    
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
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nameLabel)
        //nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        
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
        //roleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
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
            ImageUtils.loadImage(from: url, into: profileImageView)
        } else {
            profileImageView.image = UIImage(systemName: DetailsConst.Img.defaultImgNotExists)
        }
    }
}
