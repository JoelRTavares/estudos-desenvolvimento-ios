//
//  MovieDetailsViewController.swift
//  usingUIKit
//
//  Created by Joel Rosa Tavares on 24/06/25.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Properties
    var movie: Cinema.Movie?
    private var showMore = false
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(MovieInfoCell.self, forCellReuseIdentifier: "infoCell")
        tableView.register(SynopsisCell.self, forCellReuseIdentifier: "synopsisCell")
        tableView.register(CastCell.self, forCellReuseIdentifier: "castCell")
        tableView.register(PhotosCell.self, forCellReuseIdentifier: "photosCell")
        return tableView
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .background
        title = movie?.originalTitle ?? "Movie Details"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
        
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Define sections
    enum Section: Int, CaseIterable {
        case backgroundInfo
        case synopsis
        case cast
        case photos
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .backgroundInfo, .synopsis, .photos:
            return 1
        case .cast:
            return min(movie?.cast.count ?? 0, DetailsConst.prefixItems)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
            case .backgroundInfo:
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! MovieInfoCell
                if let movie = movie {
                    cell.configure(with: movie)
                }
                return cell
                
            case .synopsis:
                let cell = tableView.dequeueReusableCell(withIdentifier: "synopsisCell", for: indexPath) as! SynopsisCell
                if let overview = movie?.overview {
                    cell.configure(with: overview, showMore: showMore)
                    cell.showMoreButton.addTarget(self, action: #selector(toggleShowMore), for: .touchUpInside)
                }
                return cell
                
            case .cast:
                let cell = tableView.dequeueReusableCell(withIdentifier: "castCell", for: indexPath) as! CastCell
                if let actor = movie?.cast[indexPath.row] {
                    cell.configure(with: actor)
                }
                return cell
                
            case .photos:
                let cell = tableView.dequeueReusableCell(withIdentifier: "photosCell", for: indexPath) as! PhotosCell
                if let photos = movie?.photos {
                    let photosToShow = Array(photos.prefix(DetailsConst.prefixItems))
                    cell.configure(with: photosToShow)
                }
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionType = Section(rawValue: section),
              sectionType != .backgroundInfo else {
            return nil
        }
        
        let headerView = SectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        
        switch sectionType {
        case .synopsis:
            headerView.configure(title: "Synopsis", hasViewAll: false)
        case .cast:
            headerView.configure(title: "Cast", hasViewAll: true)
            headerView.viewAllButton.addTarget(self, action: #selector(showFullCast), for: .touchUpInside)
        case .photos:
            headerView.configure(title: "Photos", hasViewAll: true)
            headerView.viewAllButton.addTarget(self, action: #selector(showAllPhotos), for: .touchUpInside)
        default:
            break
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableView.automaticDimension
        }
        
        switch section {
        case .backgroundInfo:
            return 350
        case .photos:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    // MARK: - Actions
    @objc private func toggleShowMore() {
        showMore.toggle()
        tableView.reloadSections(IndexSet(integer: Section.synopsis.rawValue), with: .automatic)
    }
    
    @objc private func showFullCast() {
        guard let movie = movie else { return }
        let fullCastVC = FullCastViewController(cast: movie.cast)
        navigationController?.pushViewController(fullCastVC, animated: true)
    }
    
    @objc private func showAllPhotos() {
        guard let movie = movie else { return }
        let fullPhotosVC = FullPhotosViewController(photos: movie.photos)
        navigationController?.pushViewController(fullPhotosVC, animated: true)
    }
}

// MARK: - Section Header View
class SectionHeaderView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let viewAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View All", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(viewAllButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        viewAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            viewAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            viewAllButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(title: String, hasViewAll: Bool) {
        titleLabel.text = title
        viewAllButton.isHidden = !hasViewAll
    }
}

// MARK: - Constants
struct DetailsConst {
    static let maxCharCount = 150
    static let prefixItems = 3
    static let voteFormat = "%.1f"
    
    struct Ids{
        static let castCellId = "castCell"
        static let photoCellId = "photoCell"
    }
    
    struct Img {
        static let circleSize = 48.0
        static let aspectRatio = 16.0/9.0
        static let cornerRadius = 8.0
        static let spacing = 16.0
        static let defaultImgNotFound = "photo"
        static let defaultImgNotExists = "person.crop.circle"
    }
}
