//
//  ViewController.swift
//  withUIKit
//
//  Created by Joel Tavares on 20/06/25.
//

import UIKit

class ViewController: UIViewController {
    var movies = [Cinema.Movie]()
    private var viewModel = CompanySystemViewModel()
    private var currentMovies = true
    
    private var currentMoviesButton: UIButton!
    private var upcomingMoviesButton: UIButton!
    
    private lazy var headerTextView: UIStackView = {
        let titleTextView = UILabel()
        titleTextView.textAlignment = .left
        titleTextView.font = UIFont.boldSystemFont(ofSize: 26)
        titleTextView.text = "CI&T Movies"
        
        let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchImageView.contentMode = .scaleAspectFit
        searchImageView.tintColor = .reverseBackground
        let stackView = UIStackView(arrangedSubviews: [titleTextView, searchImageView])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private lazy var headerButtonsView: UIStackView = {
        currentMoviesButton = UIButton(type: .system)
        currentMoviesButton.setTitle("Current Movies", for: .normal)
        currentMoviesButton.setTitleColor(.white, for: .normal)
        currentMoviesButton.backgroundColor = currentMovies ? .red : .darkGray
        currentMoviesButton.addTarget(self, action: #selector(changeToCurrentMovies), for: .touchUpInside)
        
        upcomingMoviesButton = UIButton(type: .system)
        upcomingMoviesButton.setTitle("Upcoming Movies", for: .normal)
        upcomingMoviesButton.setTitleColor(.white, for: .normal)
        upcomingMoviesButton.backgroundColor = !currentMovies ? .red : .darkGray
        upcomingMoviesButton.addTarget(self, action: #selector(changeToIncommingMovies), for: .touchUpInside)

        
        let stackView = UIStackView(arrangedSubviews: [
            currentMoviesButton,
            upcomingMoviesButton
        ])
        stackView.backgroundColor = .darkGray
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        
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
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background

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
        view.addSubview(headerTextView)
        view.addSubview(headerButtonsView)
        view.addSubview(movieOnListColView)
    }
    private func setConstrains(){
        headerTextView.translatesAutoresizingMaskIntoConstraints = false
        movieOnListColView.translatesAutoresizingMaskIntoConstraints = false
        headerButtonsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            headerTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            headerTextView.heightAnchor.constraint(equalToConstant: 40),
            
            headerButtonsView.topAnchor.constraint(equalTo: headerTextView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            headerButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            headerButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            headerButtonsView.heightAnchor.constraint(equalToConstant: 30),
            
            movieOnListColView.topAnchor.constraint(equalTo: headerButtonsView.bottomAnchor, constant: 10),
            movieOnListColView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieOnListColView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieOnListColView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func changeToCurrentMovies(){
        currentMovies = true
        self.movies = viewModel.searchByReleaseDateComparingNow(beforeNow: true)
        updateButtonAppearance()
        movieOnListColView.reloadData()
        
        if !movies.isEmpty {
            movieOnListColView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    @objc func changeToIncommingMovies(){
        currentMovies = false
        self.movies = viewModel.searchByReleaseDateComparingNow(beforeNow: false)
        updateButtonAppearance()
        movieOnListColView.reloadData()
        
        if !movies.isEmpty {
            movieOnListColView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    private func updateButtonAppearance() {
        currentMoviesButton.backgroundColor = currentMovies ? .red : .darkGray
        upcomingMoviesButton.backgroundColor = !currentMovies ? .red : .darkGray
        
        UIView.animate(withDuration: 0.3) {
            self.currentMoviesButton.transform = self.currentMovies ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
            self.upcomingMoviesButton.transform = !self.currentMovies ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.currentMoviesButton.transform = .identity
                self.upcomingMoviesButton.transform = .identity
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        let detailsVC = MovieDetailsViewController()
        detailsVC.title = movie.title
        detailsVC.movie = movie
        navigationController?.pushViewController(detailsVC, animated: true)
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
    func goToMovieDetails(_ cell: MovieCollectionViewCell) {
        guard let indexPath = movieOnListColView.indexPath(for: cell) else { return }
        let movie = movies[indexPath.item]
        let detailsVC = MovieDetailsViewController()
        detailsVC.title = movie.title
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func didUpdateMovies(_ movies: [Cinema.Movie]) {
        self.movies = viewModel.searchByReleaseDateComparingNow(beforeNow: true)
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
