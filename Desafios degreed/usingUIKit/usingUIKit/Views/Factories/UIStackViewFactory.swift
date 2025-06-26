//
//  UIStackViewFactory.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import Foundation
import UIKit

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
