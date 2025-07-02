//
//  UIScrolFactoryTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 02/07/25.
//

import XCTest
@testable import usingUIKit
import UIKit

final class UIScrolFactoryTests: XCTestCase {

    func testScrollView(){
        let scroll = UIScrollViewFactory.createHorizontalScrollView()
        
        XCTAssertFalse(scroll.translatesAutoresizingMaskIntoConstraints, "translateAutoresizingMaskIntoConstraints deveria ser false")
        XCTAssertFalse(scroll.showsHorizontalScrollIndicator, "showsHorizontalScrollIndicator deveria ser false")
    }

}
