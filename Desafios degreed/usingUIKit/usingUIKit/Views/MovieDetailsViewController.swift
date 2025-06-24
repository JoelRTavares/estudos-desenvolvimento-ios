//
//  MovieDetailsViewController.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 24/06/25.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var movie : Cinema.Movie?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = movie?.originalTitle ?? "Loading..."
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(greaterThanOrEqualTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(greaterThanOrEqualTo: view.centerYAnchor),

            ])
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
