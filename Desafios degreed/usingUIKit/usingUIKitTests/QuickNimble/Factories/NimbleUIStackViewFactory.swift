//
//  NimbleUIStackViewFactory.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 07/07/25.
//

import Foundation
import Quick
import Nimble
@testable import usingUIKit

final class UIStackFactoryTestsSpec: QuickSpec {
    override class func spec() {
        
        describe("UIStackViewFactory") {
            
            context("quando cria um horizontal stack sem parâmetros") {
                let stackView = UIStackViewFactory.createHorizontalStackView()
                
                it("deve ter o eixo horizontal") {
                    expect(stackView.axis).to(equal(.horizontal))
                }
                it("deve ter um spacing de 8") {
                    expect(stackView.spacing).to(equal(8))
                }
                it("deve ter um alignment center") {
                    expect(stackView.alignment).to(equal(.center))
                }
                it("deve ter translatesAutoresizingMaskIntoConstraints como false") {
                    expect(stackView.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
            }
            
            context("quando cria um horizontal stack com parâmetros") {
                let stackView = UIStackViewFactory.createHorizontalStackView(spacing: 16, alignment: .fill)
                
                it("deve ter o eixo horizontal") {
                    expect(stackView.axis).to(equal(.horizontal))
                }
                it("deve ter um spacing de 16") {
                    expect(stackView.spacing).to(equal(16))
                }
                it("deve ter um alignment fill") {
                    expect(stackView.alignment).to(equal(.fill))
                }
                it("deve ter translatesAutoresizingMaskIntoConstraints como false") {
                    expect(stackView.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
            }
            
            context("quando cria um vertical stack sem parâmetros") {
                let stackView = UIStackViewFactory.createVerticalStackView()
                
                it("deve ter o eixo vertical") {
                    expect(stackView.axis).to(equal(.vertical))
                }
                it("deve ter um spacing de 8") {
                    expect(stackView.spacing).to(equal(8))
                }
                it("deve ter um alignment leading") {
                    expect(stackView.alignment).to(equal(.leading))
                }
                it("deve ter translatesAutoresizingMaskIntoConstraints como false") {
                    expect(stackView.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
            }
            
            context("quando cria um vertical stack com parâmetros") {
                let stackView = UIStackViewFactory.createVerticalStackView(spacing: 16, alignment: .fill)
                
                it("deve ter o eixo vertical") {
                    expect(stackView.axis).to(equal(.vertical))
                }
                it("deve ter um spacing de 16") {
                    expect(stackView.spacing).to(equal(16))
                }
                it("deve ter um alignment fill") {
                    expect(stackView.alignment).to(equal(.fill))
                }
                it("deve ter translatesAutoresizingMaskIntoConstraints como false") {
                    expect(stackView.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                }
            }
        }
    }
}
