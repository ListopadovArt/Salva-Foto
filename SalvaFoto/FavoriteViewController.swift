//
//  FavoriteViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit
import SwiftyKeychainKit

class FavoriteViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        return collection
    }()
    
    let noItemImage = UIImageView()
    let noItemLable = UILabel()
    var activityView: UIActivityIndicatorView?
    
    // Keychain
    let keychain = Keychain(service: "storage")
    let accessTokenKey = KeychainKey<String>(key: "key")
    
    var imageArray = [Photo]()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        style()
        layout()
        setupRefreshControl()
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func checkFavorite() {
        hideActivityIndicator()
        if imageArray.isEmpty {
            noItemImage.isHidden = false
            noItemLable.isHidden = false
        } else {
            noItemImage.isHidden = true
            noItemLable.isHidden = true
        }
    }
    
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        activityView?.color = .appColor
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
}

extension FavoriteViewController {
    
    private func style() {
        view.backgroundColor = .backgroundColor
        self.navigationController?.isNavigationBarHidden = true
        
        // Collection View
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.backgroundColor = .backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //         No Item
        noItemImage.translatesAutoresizingMaskIntoConstraints = false
        noItemImage.image = UIImage(named: "No Favorite illustration")
        noItemImage.isHidden = true
        
        noItemLable.translatesAutoresizingMaskIntoConstraints = false
        noItemLable.textAlignment = .center
        noItemLable.font = UIFont.preferredFont(forTextStyle: .title3)
        noItemLable.numberOfLines = 1
        noItemLable.textColor = .white
        noItemLable.text = "No Favorites Photos Yet"
        noItemLable.isHidden = true
    }
    
    private func layout() {
        view.addSubview(collectionView)
        view.addSubview(noItemImage)
        view.addSubview(noItemLable)
        
        NSLayoutConstraint.activate([
            noItemImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noItemImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            noItemLable.centerXAnchor.constraint(equalTo: noItemImage.centerXAnchor),
            noItemLable.topAnchor.constraint(equalTo: noItemImage.bottomAnchor, constant: 20),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - Collection View Methods
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension FavoriteViewController {
    
    private func checkProfile() {
        let token = try? keychain.get(accessTokenKey)
        if  let token = token {
            let url = "https://api.unsplash.com/me?access_token=\(token)"
            ProfileManager.shared.fetchProfile(with: url) { result in
                switch result {
                case .success(let profile):
                    self.configureProfile(with: profile)
                case .failure(let error):
                    self.displayError(error)
                }
            }
        } else {
            let controller = LoginViewController()
            controller.modalPresentationStyle = .currentContext
            controller.modalTransitionStyle = .crossDissolve
            controller.delegate = self
            navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    private func reloadView() {
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
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
}

// MARK: Actions
extension FavoriteViewController {
    @objc func refreshContent() {
        reset()
        checkProfile()
        collectionView.reloadData()
    }
    
    private func reset() {
        imageArray = []
    }
}

extension FavoriteViewController: LoginViewDelegate {
    
    func configureProfile(with profile: User) {
        
        guard let token = try? keychain.get(accessTokenKey) else {
            return
        }
        
        if let username = profile.username {
            showActivityIndicator()
            FavoriteManager.shared.fetchFavoritePhotos(username: username, token: token) { result in
                switch result {
                case .success(let images):
                    self.imageArray = images
                    self.checkFavorite()
                case .failure(let error):
                    self.displayError(error)
                }
                DispatchQueue.main.async {
                    self.reloadView()
                }
            }
        }
    }
}

// MARK: Unit testing
extension FavoriteViewController {
    func titleAndMessageForTesting(for error: NetworkError) -> (String, String) {
        return titleAndMessage(for: error)
    }
}
