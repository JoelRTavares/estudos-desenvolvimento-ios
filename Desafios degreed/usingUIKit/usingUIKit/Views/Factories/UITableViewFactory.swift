//
//  UITableViewFactory.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 26/06/25.
//

import Foundation
import UIKit

class UITableViewFactory {
    static func createTableView(cell: UITableViewCell.Type, cellIdentifier: String) -> UITableView {
        let tableView = UITableView()
        //tableView.delegate = self//Deverá atribuir ambos após a chamada do método
        //tableView.dataSource = self
        tableView.register(cell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        return tableView
    }
}
