//
//  UIScrollViewFactory.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import Foundation
import UIKit

class UIScrollViewFactory {
    static func createHorizontalScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
}
