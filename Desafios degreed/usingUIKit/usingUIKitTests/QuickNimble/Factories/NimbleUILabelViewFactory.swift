//
//  NimbleUILabelViewFactory.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 07/07/25.
//

import Quick
import Nimble
@testable import usingUIKit
import UIKit

final class UILabelFactoryTestsSpec: QuickSpec {
    override class func spec() {
        
        describe("UILabelFactory") {
            
            context("quando cria um título label") {
                let title = UILabelFactory.createTitleLabel()
                
                it("deve ter translatesAutoresizingMaskIntoConstraints como false") {
                    expect(title.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
                it("deve ter numberOfLines igual a 0") {
                    expect(title.numberOfLines).to(equal(0))
                }
                it("deve ter a fonte systemFont(ofSize: 24, weight: .bold)") {
                    expect(title.font).to(equal(UIFont.systemFont(ofSize: 24, weight: .bold)))
                }
                it("deve ter alinhamento de texto natural") {
                    expect(title.textAlignment).to(equal(.natural))
                }
            }

            context("quando cria um rating label") {
                let rating = UILabelFactory.createRatingLabel()
                
                it("deve ter translatesAutoresizingMaskIntoConstraints como false") {
                    expect(rating.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
                it("deve ter numberOfLines igual a 1") {
                    expect(rating.numberOfLines).to(equal(1))
                }
                it("deve ter a fonte systemFont(ofSize: 34, weight: .bold)") {
                    expect(rating.font).to(equal(UIFont.systemFont(ofSize: 34, weight: .bold)))
                }
                it("deve ter a cor do texto como .systemRed") {
                    expect(rating.textColor).to(equal(.systemRed))
                }
                it("deve ter alinhamento de texto natural") {
                    expect(rating.textAlignment).to(equal(.natural))
                }
            }
            
            context("quando cria um label com texto e alinhamento") {
                let title = "New Title"
                let alignment: NSTextAlignment = .center
                
                let label = UILabelFactory.createLabel(text: title, alignment: alignment)
                
                it("deve ter o texto igual a '\(title)'") {
                    expect(label.text).to(equal(title))
                }
                it("deve ter alinhamento igual a '\(alignment)'") {
                    expect(label.textAlignment).to(equal(alignment))
                }
                it("deve ter translatesAutoresizingMaskIntoConstraints como false") {
                    expect(label.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
                it("deve ter numberOfLines igual a 1") {
                    expect(label.numberOfLines).to(equal(1))
                }
                it("deve ter a fonte systemFont(ofSize: 16, weight: .regular)") {
                    expect(label.font).to(equal(UIFont.systemFont(ofSize: 16, weight: .regular)))
                }
            }
        }
    }
}
