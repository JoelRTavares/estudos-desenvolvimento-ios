//
//  UILabelFactory.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import Foundation
import UIKit


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
