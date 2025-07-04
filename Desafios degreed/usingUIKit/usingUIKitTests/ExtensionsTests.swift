//
//  ExtensionsTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 03/07/25.
//

import XCTest
@testable import usingUIKit
import UIKit
import SwiftDate

final class ExtensionsTests: XCTestCase {
    func testyyyyMMdd_DateExt(){
        let dateStr = "2020-07-03"
        let dateFormatted = DateFormatter.yyyyMMdd.date(from: dateStr) ?? Date()
        
        XCTAssertEqual(dateFormatted.year, 2020)
        XCTAssertEqual(dateFormatted.month, 7)
        XCTAssertEqual(dateFormatted.day, 3)
    }
    
}
