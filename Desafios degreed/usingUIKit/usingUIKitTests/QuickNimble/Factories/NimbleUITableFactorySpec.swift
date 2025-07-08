//
//  NimbleUITableFactorySpec.swift
//  usingUIKitTests
//
//  Created by Joel Rosa Tavares on 07/07/25.
//


import Foundation
import Quick
import Nimble

@testable import usingUIKit
import UIKit


final class UITableViewFactorySpec: QuickSpec {
    override class func spec() {
        describe("UITableViewFactory") {
            context("quando cria uma UITableView") {
                let tableView = UITableViewFactory.createTableView(
                    cell: CastCell.self,
                    cellIdentifier: DetailsConst.Ids.castCellId
                )
                it("deve ter separatorStyle igual a none") {
                    expect(tableView.separatorStyle).to(equal(UITableViewCell.SeparatorStyle.none))
                }
                it("deve ter backgroundColor igual a .backgrounf"){
                    expect(tableView.backgroundColor).to(equal(.background))
                }
            }
        }
    }
}
