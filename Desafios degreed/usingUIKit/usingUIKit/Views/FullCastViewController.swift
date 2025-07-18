//
//  FullCastViewController.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 25/06/25.
//

import UIKit

class FullCastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let cast: [Cinema.Movie.Actor]
    
    private lazy var tableView = UITableViewFactory.createTableView(cell: CastCell.self, cellIdentifier: DetailsConst.Ids.castCellId)
    
    
    init(cast: [Cinema.Movie.Actor]) {
        self.cast = cast
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        super.viewDidLoad()
        title = "Cast & Crew"
        view.backgroundColor = .background
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailsConst.Ids.castCellId, for: indexPath) as! CastCell
        cell.configure(with: cast[indexPath.row])
        return cell
    }
}
