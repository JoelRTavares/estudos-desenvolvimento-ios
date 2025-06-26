//
//  SynopsisViewCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import UIKit

class SynopsisCell: UITableViewCell {
    private lazy var synopsisLabel = UILabelFactory.createLabel(fontSize: 16)
    lazy var showMoreButton = UIButtonFactory.createButton(title: "Show more")
    private lazy var stackView = UIStackViewFactory.createVerticalStackView()
    
    
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
        stackView.addArrangedSubview(synopsisLabel)
        stackView.addArrangedSubview(showMoreButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with synopsis: String, showMore: Bool) {
        if synopsis.count < DetailsConst.maxCharCount {
            synopsisLabel.text = synopsis
            showMoreButton.isHidden = true
        } else {
            if showMore {
                synopsisLabel.text = synopsis
                showMoreButton.setTitle("Show less", for: .normal)
            } else {
                let maxCharIndex = min(synopsis.count, DetailsConst.maxCharCount)
                synopsisLabel.text = String(synopsis.prefix(maxCharIndex)) + "..."
                showMoreButton.setTitle("Show more", for: .normal)
            }
            showMoreButton.isHidden = false
        }
    }
}

