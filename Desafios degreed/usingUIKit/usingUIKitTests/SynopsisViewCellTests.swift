//
//  SynopsisViewCellTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 03/07/25.
//

import UIKit
@testable import usingUIKit
import XCTest


final class SynopsisViewCellTests: XCTestCase {

    func testConfigure_withShortSynopsis_hidesButton() {
        let cell = SynopsisCell(style: .default, reuseIdentifier: nil)
        let shortSynopsis = "Curto"
        cell.configure(with: shortSynopsis, showMore: false)

        XCTAssertEqual(cell.synopsisLabel.text, shortSynopsis)
        XCTAssertTrue(cell.showMoreButton.isHidden)
    }

    func testConfigure_withLongSynopsisAndShowMoreFalse_truncatesText() {
        let longSynopsis = String(repeating: "a", count: DetailsConst.maxCharCount + 10)
        let cell = SynopsisCell(style: .default, reuseIdentifier: nil)
        cell.configure(with: longSynopsis, showMore: false)

        XCTAssertTrue(cell.synopsisLabel.text!.hasSuffix("..."))
        XCTAssertEqual(cell.synopsisLabel.text?.count, DetailsConst.maxCharCount + 3)
        XCTAssertFalse(cell.showMoreButton.isHidden)
        XCTAssertEqual(cell.showMoreButton.title(for: .normal), "Show more")
    }

    func testConfigure_withLongSynopsisAndShowMoreTrue_showsFullText() {
        let longSynopsis = String(repeating: "a", count: DetailsConst.maxCharCount + 10)
        let cell = SynopsisCell(style: .default, reuseIdentifier: nil)
        cell.configure(with: longSynopsis, showMore: true)

        XCTAssertEqual(cell.synopsisLabel.text, longSynopsis)
        XCTAssertEqual(cell.showMoreButton.title(for: .normal), "Show less")
    }


}
