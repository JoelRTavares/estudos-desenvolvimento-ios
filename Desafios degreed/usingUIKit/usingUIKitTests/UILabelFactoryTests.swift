//
//  UILabelFactoryTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 02/07/25.
//

import XCTest
@testable import usingUIKit
import UIKit

final class UILabelFactoryTests: XCTestCase {

    func testCreateTitleLabel(){
        let title = UILabelFactory.createTitleLabel()
        
        XCTAssertFalse(title.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deveria ser false")
        XCTAssertEqual(title.numberOfLines, 0, "numberOfLines deveria ser 0")
        XCTAssertEqual(title.font, .systemFont(ofSize: 24, weight: .bold), "Fonte deve ser systemFont(ofSize: 24, weight: .bold")
        XCTAssertEqual(title.textAlignment, .natural, "Alinhamento do título deveria ser natural")
    }

    func testCreateRatingLabel(){
        let rating = UILabelFactory.createRatingLabel()
        
        XCTAssertFalse(rating.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deveria ser false")
        XCTAssertEqual(rating.numberOfLines, 1, "numberOfLines deveria ser 1")
        XCTAssertEqual(rating.font, .systemFont(ofSize: 34, weight: .bold),  "Fonte deve ser systemFont(ofSize: 34, weight: .bold")
        XCTAssertEqual(rating.textColor, .systemRed, "Fonte deve ser .systemRed")
        XCTAssertEqual(rating.textAlignment, .natural, "Alinhamento do título deveria ser natural")
    }
    
    func testCreateLabel(){
        let title = "New Title"
        let alignment: NSTextAlignment = .center//Apenas com os atributos ainda não testados
        let label = UILabelFactory.createLabel(text: title, alignment: alignment)
        
        XCTAssertEqual(label.text, title, "Title deveria ser '\(title)'")
        XCTAssertEqual(label.textAlignment, alignment, "alignment deveria ser '\(alignment)'")
        XCTAssertFalse(label.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deveria ser false")
        
        XCTAssertEqual(label.numberOfLines, 1, "numberOfLines deveria ser 1")
        XCTAssertEqual(label.font, .systemFont(ofSize: 16, weight: .regular),  "Fonte deve ser systemFont(ofSize: 16, weight: .regular")
    }
}
