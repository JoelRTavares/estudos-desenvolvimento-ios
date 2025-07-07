//
//  NimbleUIFactoryButton.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 07/07/25.
//

import Foundation

import Foundation
import Quick
import Nimble

@testable import usingUIKit
import UIKit

final class UIButtonFactorySpec: QuickSpec {
    override class func spec() {
        describe("UIButtonFactory") {
        context("when creating a button") {
        let title = "Clique Aqui"
        let button = UIButtonFactory.createButton(title: title)

                    it("should have the correct title") {
                        expect(button.title(for: .normal)).to(equal(title))
                    }

                    it("should have translatesAutoresizingMaskIntoConstraints set to false") {
                        expect(button.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                    }

                    
                    it("should have a button type of .system") {
                        expect(button.buttonType).to(equal(UIButton.ButtonType.system))
                    }
                }

                context("when checking button properties") {
                    let title = "Test Button"
                    let button = UIButtonFactory.createButton(title: title)

                    it("should have a non-nil default title color") {
                        let defaultTitleColor = button.titleColor(for: .normal)
                        expect(defaultTitleColor).toNot(beNil())
                    }

                    it("should have a non-nil default font") {
                        let defaultFont = button.titleLabel?.font
                        expect(defaultFont).toNot(beNil())
                    }
                }
            }
    }

}
