//
//  UIStackFactoryTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 02/07/25.
//

import UIKit
@testable import usingUIKit
import XCTest

final class UIStackFactoryTests: XCTestCase {

    func testHorizontalStackWithoutParameters() {
        let stackView = UIStackViewFactory.createHorizontalStackView()
        
        XCTAssertEqual(stackView.axis, .horizontal, "Axis deveria ser horizontal")
        XCTAssertEqual(stackView.spacing, 8, "Spacing deveria ser 8")
        XCTAssertEqual(stackView.alignment, .center, "Alignment deveria ser center")
        XCTAssertFalse(stackView.translatesAutoresizingMaskIntoConstraints, "translateAutoresizingMaskIntoConstraints deveria ser false")
    }
    
    func testHorizontalStackWithParameters() {
        let stackView = UIStackViewFactory.createHorizontalStackView(spacing: 16, alignment: .fill)
        
        XCTAssertEqual(stackView.axis, .horizontal, "Axis deveria ser horizontal")
        XCTAssertEqual(stackView.spacing, 16, "Spacing deveria ser 16")
        XCTAssertEqual(stackView.alignment, .fill, "Alignment deveria ser fill")
        XCTAssertFalse(stackView.translatesAutoresizingMaskIntoConstraints, "translateAutoresizingMaskIntoConstraints deveria ser false")
    }

    func testVerticalStackWithoutParameters() {
        let stackView = UIStackViewFactory.createVerticalStackView()
        
        XCTAssertEqual(stackView.axis, .vertical, "Axis deveria ser vertical")
        XCTAssertEqual(stackView.spacing, 8, "Spacing deveria ser 8")
        XCTAssertEqual(stackView.alignment, .leading, "Alignment deveria ser leading")
        XCTAssertFalse(stackView.translatesAutoresizingMaskIntoConstraints, "translateAutoresizingMaskIntoConstraints deveria ser false")
    }
    
    func testVerticalStackWithParameters() {
        let stackView = UIStackViewFactory.createVerticalStackView(spacing: 16, alignment: .fill)
        
        XCTAssertEqual(stackView.axis, .vertical, "Axis deveria ser vertical")
        XCTAssertEqual(stackView.spacing, 16, "Spacing deveria ser 16")
        XCTAssertEqual(stackView.alignment, .fill, "Alignment deveria ser fill")
        XCTAssertFalse(stackView.translatesAutoresizingMaskIntoConstraints, "translateAutoresizingMaskIntoConstraints deveria ser false")
    }
    
}
