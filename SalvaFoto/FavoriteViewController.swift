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
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
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
    }
    
    private func layout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
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
    
    private func showErrorAlert(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
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
            FavoriteManager.shared.fetchFavoritePhotos(username: username, token: token) { result in
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
    }
}
