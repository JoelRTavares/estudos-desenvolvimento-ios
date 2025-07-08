//
//  NimbleUIImageFactory.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 07/07/25.
//

import Foundation
import Quick
import Nimble

@testable import usingUIKit
import UIKit


final class UIImageFactorySpec: QuickSpec {
    override class func spec() {
        describe("UIImageViewFactory") {
            context("quando chama createBackdropImageView") {
                let imageView = UIImageViewFactory.createBackdropImageView()

                it("deve ter tamic igual a false") {
                    expect(imageView.translatesAutoresizingMaskIntoConstraints).to(equal(false))
                }
                it("deve ter contentMode igual a .scaleAspectFit"){
                    expect(imageView.contentMode).to(equal(.scaleAspectFit))
                }
                it("deve ter clipToBounds igual a true"){
                    expect(imageView.clipsToBounds).to(equal(true))
                }
            }
            
            context("quando chama createCircleImageView"){
                let size = 20.0
                let imageView = UIImageViewFactory.createCircleImageView(size: size)
                
                it("deve ter cornerRadius igual a metade do tamanho"){
                    expect(imageView.layer.cornerRadius).to(equal(size/2))
                }
                it("deve ter tamic igual a false") {
                    expect(imageView.translatesAutoresizingMaskIntoConstraints).to(equal(false))
                }
                it("deve ter altura e largura iguais a size"){
                    let widthConstraint = imageView.constraints.first { $0.firstAttribute == .width }
                    let heightConstraint = imageView.constraints.first { $0.firstAttribute == .height }

                    expect(widthConstraint?.constant ?? -1.0).to(equal(size))
                    expect(heightConstraint?.constant ?? -1.0).to(equal(size))
                }
            }
            
            context("quando chama createAspectFitImageView"){
                let corner = 10.0
                let imageView = UIImageViewFactory.createAspectFitImageView(cornerRadius: corner)
                it("deve ter cornerRadius igual a corner"){
                    expect(imageView.layer.cornerRadius).to(equal(corner))
                }
                
                it("deve ter tamic igual a false") {
                    expect(imageView.translatesAutoresizingMaskIntoConstraints).to(equal(false))
                }
                it("deve ter contentMode igual a .scaleAspectFit"){
                    expect(imageView.contentMode).to(equal(.scaleAspectFit))
                }
                it("deve ter clipToBounds igual a true"){
                    expect(imageView.clipsToBounds).to(equal(true))
                }
            }
            
            context("quando chama createAspectFillImageView"){
                let corner = 10.0
                let imageView = UIImageViewFactory.createAspectFillImageView(cornerRadius: corner)
                
                it("deve ter cornerRadius igual a corner"){
                    expect(imageView.layer.cornerRadius).to(equal(corner))
                }
                
                it("deve ter tamic igual a false") {
                    expect(imageView.translatesAutoresizingMaskIntoConstraints).to(equal(false))
                }
                it("deve ter contentMode igual a .scaleToFill"){
                    expect(imageView.contentMode).to(equal(.scaleToFill))
                }
                it("deve ter clipToBounds igual a true"){
                    expect(imageView.clipsToBounds).to(equal(true))
                }
            }
            
            context("quando chamar createAspectFillSystemImageView") {
                let color: UIColor = .blue
                let img = "person.circle"
                let imageView = UIImageViewFactory.createAspectFillSystemImageView(image: img, color: color)
                
                it("deve ter contentMode igual a .scaleAspectFill"){
                    expect(imageView.contentMode).to(equal(.scaleAspectFill))
                }
                it("deve ter tintColor igual a cor passada"){
                    expect(imageView.tintColor).to(equal(color))
                }
                it("deve ter imagem igual a imagem passada"){
                    let systemImage = UIImage(systemName: img)
                    expect(imageView.image?.pngData()).to(equal(systemImage?.pngData()))
                }
            }
        }
    }
}
