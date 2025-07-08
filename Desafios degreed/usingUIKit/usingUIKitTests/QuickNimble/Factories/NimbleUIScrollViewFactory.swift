//
//  NimbleUIScrollViewFactory.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 07/07/25.
//

import Foundation
import Quick
import Nimble

@testable import usingUIKit
import UIKit


final class UIScrollViewFactorySpec: QuickSpec {
    override class func spec() {
        
        describe("UIScrollViewFactory") {
            context("quando cria uma UIScrollView") {
                let scrollView = UIScrollViewFactory.createHorizontalScrollView()
                it("deve ter tamic igual a false") {
                    expect(scrollView.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
                it("deve ter showsHorizontalScrollIndicator igual a false"){
                    expect(scrollView.showsHorizontalScrollIndicator).to(beFalse())
                }
            }
        }
    }
}
