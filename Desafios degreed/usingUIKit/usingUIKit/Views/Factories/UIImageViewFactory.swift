//
//  UIImageViewFactory.swift
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
