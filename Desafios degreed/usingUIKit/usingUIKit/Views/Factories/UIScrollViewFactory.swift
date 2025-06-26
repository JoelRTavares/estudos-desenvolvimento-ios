//
//  UIScrollViewFactory.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import Foundation
import UIKit

class UIImageViewFactory {
    static func createBackdropImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    static func createCircleImageView(size: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = size / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: size),
            imageView.heightAnchor.constraint(equalToConstant: size)
        ])
        
        return imageView
    }
    
    static func createAspectFitImageView(cornerRadius: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = cornerRadius
        return imageView
    }
    
    static func createAspectFillImageView(cornerRadius: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = cornerRadius
        return imageView
    }
    
    static func createAspectFillSystemImageView(image: String, color: UIColor) -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: image))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = color
        return imageView
    }
}

class UILabelFactory {
    static func createTitleLabel() -> UILabel {
        return createLabel(fontSize: 24, weight: .bold, numberOfLines: 0)
    }
    
    static func createRatingLabel() -> UILabel {
        let label = createLabel(fontSize: 34, weight: .bold)
        label.textColor = .systemRed
        return label
    }
    
    static func createLabel(text: String = "", fontSize: CGFloat = 16, weight: UIFont.Weight = .regular, numberOfLines: Int = 1, alignment: NSTextAlignment = .natural) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: fontSize, weight: weight)
        label.numberOfLines = numberOfLines
        label.textAlignment = alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

class UIButtonFactory {
    static func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

class UIStackViewFactory {
    static func createHorizontalStackView(spacing: CGFloat = 8, alignment: UIStackView.Alignment = .center) -> UIStackView {
        return createStackView(axis: .horizontal, spacing: spacing, alignment: alignment)
    }
    
    static func createVerticalStackView(spacing: CGFloat = 8, alignment: UIStackView.Alignment = .leading) -> UIStackView {
        return createStackView(axis: .vertical, spacing: spacing, alignment: alignment)
    }
    
    static func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
}

class UItableViewFactory {
    static func createTableView(cell: UITableViewCell.Type, cellIdentifier: String) -> UITableView {
        let tableView = UITableView()
        //tableView.delegate = self//Deverá atribuir ambos após a chamada do método
        //tableView.dataSource = self
        tableView.register(cell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        return tableView
    }
}

class UIScrollViewFactory {
    static func createHorizontalScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
}
