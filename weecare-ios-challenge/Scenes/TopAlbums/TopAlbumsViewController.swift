//
//  TopAlbumsViewController.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

enum TopAlbumsFilter {
    case comingSoon, hotTracks, newReleases, topAlbums, topSongs
}

extension TopAlbumsFilter {
    var name: String {
        switch self {
        case .comingSoon:
            return "Coming Soon"
        case .hotTracks:
            return "Hot Tracks"
        case .newReleases:
            return "New Releases"
        case .topAlbums:
            return "Top Albums"
        case .topSongs:
            return "Top Songs"
        }
    }
}
final class TopAlbumsViewController: UIViewController {
    private let cache = NSCache<NSString, UIImage>()
    private let iTunesAPI: ITunesAPI
    private let networking: Networking
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var albums = [Album]() {
        didSet {
            collectionView.reloadData()
        }
    }
    private lazy var cellSize: CGSize = {
        CGSize(width: view.frame.width / 2.15, height: view.frame.width / 2.15 * 1.5)
    }()
    private var currentFilter: TopAlbumsFilter = .topAlbums {
        didSet {
            albums.removeAll()
            loadData()
            setNavigationBar()
        }
    }
    
    init(iTunesAPI: ITunesAPI, networking: Networking) {
        self.iTunesAPI = iTunesAPI
        self.networking = networking
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        setNavigationBar()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TopAlbumCollectionViewCell.self, forCellWithReuseIdentifier: TopAlbumCollectionViewCell.description())
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        loadData()
    }
    
    private func loadData() {
        iTunesAPI.getTopAlbums(filter: currentFilter) { [weak self] res in
            switch res {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.albums = data.feed.results
                }
            case .failure(let err):
                debugPrint(err)
            }
        }
    }
    
    private func downloadImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> ()) {
        let request = APIRequest(url: url)
        networking.requestData(request) { res in
            completion(res.map { data in UIImage(data: data) })
        }
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(
                title: "Coming Soon",
                image: menuItemImage(for: .comingSoon),
                handler: { _ in
                    if self.currentFilter != .comingSoon { self.currentFilter = .comingSoon }
                }
            ),
            UIAction(
                title: "Hot Tracks",
                image: menuItemImage(for: .hotTracks),
                handler: { _ in
                    if self.currentFilter != .hotTracks { self.currentFilter = .hotTracks }
                }
            ),
            UIAction(
                title: "New Releases",
                image: menuItemImage(for: .newReleases),
                handler: { _ in
                    if self.currentFilter != .newReleases { self.currentFilter = .newReleases }
                }
            ),
            UIAction(
                title: "Top Albums",
                image: menuItemImage(for: .topAlbums),
                handler: { _ in
                    if self.currentFilter != .topAlbums { self.currentFilter = .topAlbums }
                }
            ),
            UIAction(
                title: "Top Songs",
                image: menuItemImage(for: .topSongs),
                handler: { _ in
                    if self.currentFilter != .topSongs { self.currentFilter = .topSongs }
                }
            )
        ]
    }
    
    private var menu: UIMenu {
        UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    private func setNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "text.justifyleft"), primaryAction: nil, menu: menu)
        navigationItem.title = currentFilter.name
    }
    
    private func menuItemImage(for filter: TopAlbumsFilter) -> UIImage? {
        currentFilter == filter ? UIImage(systemName: "checkmark") : nil
    }
}

// MARK: - UICollectionViewDataSource
extension TopAlbumsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = albums[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopAlbumCollectionViewCell.description(), for: indexPath) as! TopAlbumCollectionViewCell
        cell.albumLabel.text = album.name
        cell.artistNameLabel.text = album.artistName
        
        if let imageURL = album.artworkUrl100 {
            if let img = cache.object(forKey: album.id as NSString) {
                cell.albumImageView.image = img
            } else {
                downloadImage(url: imageURL) { [weak self, weak cell] res in
                    switch res {
                    case .success(let img):
                        guard let img = img else { return }
                        self?.cache.setObject(img, forKey: album.id as NSString)
                        DispatchQueue.main.async {
                            cell?.albumImageView.image = img
                        }
                    case .failure(let err):
                        debugPrint(err)
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize
    }
}
