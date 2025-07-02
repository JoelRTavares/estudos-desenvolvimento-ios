//
//  ImageViewFactoryTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 01/07/25.
//

import UIKit
@testable import usingUIKit
import XCTest

final class UIImageViewFactoryTests: XCTestCase {
    func testCreateBackdropImageView() {
        let imageView = UIImageViewFactory.createBackdropImageView()
        XCTAssertEqual(imageView.contentMode, .scaleAspectFit, "contentMode deve ser .scaleAspectFit")
        XCTAssertTrue(imageView.clipsToBounds, "clipsToBounds deve ser true")
        XCTAssertFalse(imageView.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deve ser false")
    }
    
    
    func testCreateCircleImageView() {
        let size: CGFloat = 100
        let imageView = UIImageViewFactory.createCircleImageView(size: size)

        XCTAssertEqual(imageView.layer.cornerRadius, size / 2, "Corner radius deve ser igual a size / 2")
        XCTAssertEqual(imageView.constraints.count, 2, "Deve ter 2 constraints (width e height)")

        // Verificar se as constraints de width e height estão corretas
        let widthConstraint = imageView.constraints.first { $0.firstAttribute == .width }
        let heightConstraint = imageView.constraints.first { $0.firstAttribute == .height }

        XCTAssertNotNil(widthConstraint, "Width constraint não deve ser nil")
        XCTAssertNotNil(heightConstraint, "Height constraint não deve ser nil")

        XCTAssertEqual(widthConstraint?.constant, size, "Width constraint deve ser igual a size")
        XCTAssertEqual(heightConstraint?.constant, size, "Height constraint deve ser igual a size")
    }

    func testCreateAspectFitImageView() {
        let cornerRadius: CGFloat = 10
        let imageView = UIImageViewFactory.createAspectFitImageView(cornerRadius: cornerRadius)

        XCTAssertEqual(imageView.contentMode, .scaleAspectFit, "contentMode deve ser .scaleAspectFit")
        XCTAssertEqual(imageView.layer.cornerRadius, cornerRadius, "Corner radius deve ser \(cornerRadius)")
        XCTAssertTrue(imageView.clipsToBounds, "clipsToBounds deve ser true")
        XCTAssertFalse(imageView.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deve ser false")
    }
    func testCreateAspectFillImageView() {
        let cornerRadius: CGFloat = 15
        let imageView = UIImageViewFactory.createAspectFillImageView(cornerRadius: cornerRadius)

        XCTAssertEqual(imageView.contentMode, .scaleToFill, "contentMode deve ser .scaleToFill")
        XCTAssertEqual(imageView.layer.cornerRadius, cornerRadius, "Corner radius deve ser \(cornerRadius)")
         XCTAssertTrue(imageView.clipsToBounds, "clipsToBounds deve ser true")
        XCTAssertFalse(imageView.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints deve ser false")
    }
    
    func testCreateAspectFillSystemImageView() {
        let imageName = "gear"
        let color = UIColor.blue
        let imageView = UIImageViewFactory.createAspectFillSystemImageView(image: imageName, color: color)

        XCTAssertEqual(imageView.contentMode, .scaleAspectFill, "contentMode deve ser .scaleAspectFill")
        XCTAssertEqual(imageView.tintColor, color, "tintColor deve ser \(color)")
        XCTAssertNotNil(imageView.image, "A imagem não deve ser nil")

        
        if let systemImage = UIImage(systemName: imageName) {
            XCTAssertEqual(imageView.image?.pngData(), systemImage.pngData(), "A imagem deve ser a do sistema com nome \(imageName)")
        } else {
            XCTFail("Não foi possível carregar a imagem do sistema \(imageName)")
        }
    }
        
}
