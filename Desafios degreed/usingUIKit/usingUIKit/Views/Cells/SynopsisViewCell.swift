//
//  SynopsisViewCell.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import UIKit

class SynopsisCell: UITableViewCell {
    private let synopsisLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show more", for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
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

