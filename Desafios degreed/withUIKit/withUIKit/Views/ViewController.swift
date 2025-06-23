//
//  ViewController.swift
//  withUIKit
//
//  Created by Joel Tavares on 20/06/25.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate {
    var movies = [Cinema.Movie]()
    private var viewModel = CompanySystemViewModel()

    private lazy var movieOnListColView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let itemWidth = (view.frame.width - 3 * spacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 5.0 / 3.0 + 80)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .lightGray

        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        movieOnListColView.register(
                MovieCollectionViewCell.self,
                forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
            )
            
        viewModel.delegate = self
        setupView()
        viewModel.loadData()
    }
    private func setupView(){
        setHierarchy()
        setConstrains()
    }
    private func setHierarchy(){
        view.addSubview(movieOnListColView)
    }
    private func setConstrains(){
        movieOnListColView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            movieOnListColView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieOnListColView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieOnListColView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieOnListColView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: movies[indexPath.item])
        return cell
    }
}
extension ViewController: CompanySystemViewModelDelegate {
    func didUpdateMovies(_ movies: [Cinema.Movie]) {
        self.movies = viewModel.orderByReleaseDate()
        movieOnListColView.reloadData()
    }
    
    func didChangeLoadingState(isLoading: Bool) {
        print(isLoading ? "Carregando..." : "Finalizado")
    }
    
    func didReceiveError(_ error: MovieError) {
        let alert = UIAlertController(title: "Erro", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let itemWidth = (view.frame.width - 3 * spacing) / 2
        return CGSize(width: itemWidth, height: itemWidth * 5.0/3.0 + 80)
    }
}
