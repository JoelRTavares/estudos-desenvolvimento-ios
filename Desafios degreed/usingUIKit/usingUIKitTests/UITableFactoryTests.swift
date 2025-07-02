//
//  UITableFactoryTests.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 02/07/25.
//

import UIKit
@testable import usingUIKit
import XCTest

final class UITableFactoryTests: XCTestCase {

    func testCreateTableView() {
        let tableView = UITableViewFactory.createTableView(cell: CastCell.self, cellIdentifier: DetailsConst.Ids.castCellId)
        
        XCTAssertEqual(tableView.backgroundColor, .background)
        XCTAssertEqual(tableView.separatorStyle, .none)
    }

}
