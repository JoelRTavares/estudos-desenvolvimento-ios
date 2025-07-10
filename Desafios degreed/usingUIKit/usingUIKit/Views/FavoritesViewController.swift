//
//  FavoritesViewController.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 08/07/25.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    var movies = [MovieRealm]()
    private var viewModel = CinemaRealmViewModel()

    
    private lazy var headerTextView: UIStackView = {
        lazy var titleTextView = UILabelFactory.createLabel(text: "Your Favorite Movies", fontSize: 26, alignment: .left)
        
        let stackView = UIStackView(arrangedSubviews: [titleTextView])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    
    
    private lazy var movieOnListColView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let itemWidth = (view.frame.width - 3 * spacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 5.0 / 3.0 + 80)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .background
        
        collectionView.register(MovieRealmCollectionViewCell.self, forCellWithReuseIdentifier: MovieRealmCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        movieOnListColView.register(
            MovieRealmCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieRealmCollectionViewCell.identifier
        )
        setupView()
        viewModel.delegate = self
        movies = viewModel.fetchAllMovies()
        movieOnListColView.reloadData()
    }
    private func setupView(){
        setHierarchy()
        setConstrains()
    }
    private func setHierarchy(){
        view.addSubview(headerTextView)
        view.addSubview(movieOnListColView)
    }
    private func setConstrains(){
        headerTextView.translatesAutoresizingMaskIntoConstraints = false
        movieOnListColView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            headerTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            headerTextView.heightAnchor.constraint(equalToConstant: 40),
            
            movieOnListColView.topAnchor.constraint(equalTo: headerTextView.bottomAnchor, constant: 10),
                    
            movieOnListColView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieOnListColView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieOnListColView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension FavoritesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieRealmCollectionViewCell.identifier, for: indexPath) as? MovieRealmCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel.delegate = self
        cell.updateDelegate = self
        cell.delegate = self
        cell.configure(with: movies[indexPath.item])
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let itemWidth = (view.frame.width - 3 * spacing) / 2
        return CGSize(width: itemWidth, height: itemWidth * 5.0/3.0 + 80)
    }
}

extension FavoritesViewController: CinemaRealmViewModelDelegate{
    func didDetectDuplicateMovie(movieName: String) {
        
        let alert = UIAlertController(title: "Atenção", message: "O filme \(movieName) não está inserido na lista de favoritos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func confirmSuccessfulOperation(movieName: String) {
        let alert = UIAlertController(title: "Sucesso", message: "O filme \(movieName) foi removido de sua lista de favoritos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        movies = viewModel.fetchAllMovies()
        movieOnListColView.reloadData()
        
    }
    
    func gotError(err: any Error) {
        let alert = UIAlertController(title: "ERRO", message: "\(err).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension FavoritesViewController: FavoriteChangeScreenDelegate {
    func pushNavigationScreen(_ screen: UIViewController) {
        navigationController?.pushViewController(screen, animated: true)
        
    }
}

extension FavoritesViewController: UpdateMovieListDelegate {
    func reloadMovies() {
        movies = viewModel.fetchAllMovies()
        movieOnListColView.reloadData()
    }  
}
