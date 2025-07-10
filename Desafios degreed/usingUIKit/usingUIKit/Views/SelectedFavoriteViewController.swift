//
//  SelectedFavoriteViewController.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 10/07/25.
//

import UIKit

protocol UpdateMovieListDelegate: AnyObject {
    func reloadMovies()
}

class SelectedFavoriteViewController: UIViewController {
    var movie: MovieRealm?
    let viewModel = CinemaRealmViewModel()
    
    weak var delegate: UpdateMovieListDelegate?

    let nameTextField = UITextField()
    let releaseDateTextField = UITextField()
    let genreTextField = UITextField()
    let ratingTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        title = "Update favorite movie"
        
        viewModel.delegate = self
        setupUI()
    }
    
    func setupUI(){
        setupTextField(nameTextField, placeholder: "Movie Name", isSecure: false, initialText: movie?.name ?? "Name")
        setupTextField(releaseDateTextField, placeholder: "Release Date", isSecure: false, initialText: movie?.releaseDate ?? "04-11-2023")
        setupTextField(genreTextField, placeholder: "Genre", isSecure: false, initialText: movie?.firstGenre ?? "Genero")
        setupTextField(ratingTextField, placeholder: "Rating", isSecure: false, initialText: "\(movie?.rating ?? 0.0)")
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        
        let stackView = UIStackViewFactory.createVerticalStackView(spacing: 16)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(releaseDateTextField)
        stackView.addArrangedSubview(genreTextField)
        stackView.addArrangedSubview(ratingTextField)
        stackView.addArrangedSubview(saveButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, isSecure: Bool, initialText: String) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.text = initialText
    }
    
    @objc func saveChanges() {
        // Atualizar filme no viewModel
        guard let movie = movie else { return }
        let updatedMovie = MovieRealm(id: movie.id,
                                      name: nameTextField.text ?? movie.name,
                                      releaseDate: releaseDateTextField.text ?? movie.releaseDate,
                                      rating: Double(ratingTextField.text ?? "\(movie.rating)") ?? movie.rating,
                                      firstGenre: genreTextField.text ?? movie.firstGenre,
                                      posterPath: movie.posterPath)
        

        viewModel.updateMovieIfExists(updatedMovie)
    }
}

extension SelectedFavoriteViewController: CinemaRealmViewModelDelegate{
    func didDetectDuplicateMovie(movieName: String) {
        let alert = UIAlertController(title: "Atenção", message: "O filme \(movieName) não está inserido na lista de favoritos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func confirmSuccessfulOperation(movieName: String) {
        delegate?.reloadMovies()
        self.navigationController?.popViewController(animated: true)
        
        let alert = UIAlertController(title: "Sucesso", message: "O filme \(movieName)  foi atualizado com sucesso em sua lista de favoritos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    func gotError(err: any Error) {
        let alert = UIAlertController(title: "ERRO", message: "\(err).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
