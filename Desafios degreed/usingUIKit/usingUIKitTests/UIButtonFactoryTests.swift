//
//  UIButtonFactoryTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 02/07/25.
//

import UIKit
@testable import usingUIKit
import XCTest

final class UIButtonFactoryTests: XCTestCase {
    func testCreateButton() {
        let title = "Clique Aqui"
        let button = UIButtonFactory.createButton(title: title)

        XCTAssertEqual(button.title(for: .normal), title, "O título do botão deve ser '\(title)'")
        XCTAssertFalse(button.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deve ser false")
        XCTAssertEqual(button.buttonType, .system, "O tipo do botão deve ser .system")
    }

    func testButtonTitleColor() {
        let title = "Test Button"
        let button = UIButtonFactory.createButton(title: title)

        let defaultTitleColor = button.titleColor(for: .normal)
        XCTAssertNotNil(defaultTitleColor, "A cor do título não deve ser nil")
    }

    func testButtonFont() {
        let title = "Test Button"
        let button = UIButtonFactory.createButton(title: title)

        let defaultFont = button.titleLabel?.font
        XCTAssertNotNil(defaultFont, "A fonte do título não deve ser nil")
    }
    
}
