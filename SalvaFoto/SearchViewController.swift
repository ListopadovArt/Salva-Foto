//
//  SearchViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        return collection
    }()
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    var imageArray = [Photo]()
    
    let refreshControl = UIRefreshControl()
    
    // https://unsplash.com/documentation#get-a-random-photo
    let accessKey = "&client_id=f9U4wUpQbGa7KBTGQp-J8umBGGWBLaTJfiaKcOkBfn0"
    let host = "https://api.unsplash.com/"
    let randomPhotos = "photos/random/?count=30"
    let searchPhotos = "search/photos?per_page=100"
    
    override func viewDidLoad() {
        style()
        layout()
        fetchData()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
}

extension SearchViewController {
    
    private func style() {
        view.backgroundColor = .backgroundColor
        self.navigationController?.isNavigationBarHidden = true
        
        // Search Bar
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = UIColor(red: 0.19, green: 0.19, blue: 0.22, alpha: 1.00)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)]
        )
        searchBar.barTintColor = .backgroundColor
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.layer.cornerRadius = 5
        searchBar.clipsToBounds = true
        
        // Collection View
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = .backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func layout() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchBar.trailingAnchor, multiplier: 2),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - Photo Search
extension SearchViewController: UISearchBarDelegate, UITextFieldDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        guard !textSearched.isEmpty else {
            return
        }
        fetchSearchData(textSearched)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.fetchData()
        return true
    }
}

//MARK: - Collection View Methods
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        let image = imageArray[indexPath.item]
        item.configure(with: image)
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = ShowImageViewController()
        let image = imageArray[indexPath.item]
        controller.image = image
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 1) / 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - Networking
extension SearchViewController {
    private func fetchData() {
        SearchManager.shared.performRandomPhotosRequest(with: "\(host)\(randomPhotos)\(accessKey)") { result in
            switch result {
            case .success(let images):
                self.imageArray = images
            case .failure(let error):
                self.displayError(error)
            }
            DispatchQueue.main.async {
                self.reloadView()
            }
        }
    }
    
    private func reloadView() {
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
    
    private func fetchSearchData(_ word: String) {
        SearchManager.shared.performPhotoSearchRequest(with: "\(host)\(searchPhotos)&query=\(word)\(accessKey)") { result in
            switch result {
            case .success(let images):
                if let photos = images.photos {
                    self.imageArray = photos
                }
            case .failure(let error):
                self.displayError(error)
            }
            DispatchQueue.main.async {
                self.reloadView()
            }
        }
    }
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Ensure you are connected to the internet. Please try again."
        }
        return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
    }
}

// MARK: Actions
extension SearchViewController {
    @objc func refreshContent() {
        reset()
        collectionView.reloadData()
        
        if searchBar.text == ""{
            fetchData()
        } else {
            fetchSearchData(searchBar.text!)
        }
    }
    
    private func reset() {
        imageArray = []
    }
}
