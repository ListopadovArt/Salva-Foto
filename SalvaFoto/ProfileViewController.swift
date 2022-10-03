//
//  ProfileViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit
import SwiftyKeychainKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    // Profile
    let profile: User? = nil
    let titleLabel = UILabel()
    let avatarImage = UIImageView()
    let bioLabel = UILabel()
    let locationImage = UIImageView()
    let locationLabel = UILabel()
    let usernameImage = UIImageView()
    let usernameLabel = UILabel()
    let likeImage = UIImageView()
    let likeLabel = UILabel()
    let photoImage = UIImageView()
    let photoLabel = UILabel()
    let collectionImage = UIImageView()
    let collectionLabel = UILabel()
    
    lazy var menuBarButton: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis")
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(menuTapped))
        barButtonItem.tintColor = .white
        return barButtonItem
    }()
    
    
    // Keychain
    let keychain = Keychain(service: "storage")
    let accessTokenKey = KeychainKey<String>(key: "key")
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layoutProfile()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = menuBarButton
    }
}

extension ProfileViewController {
    private func style() {
        self.view.backgroundColor = .backgroundColor
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        
        // Image
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.clipsToBounds = true
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.layer.cornerRadius = 5
        
        // Location
        locationImage.translatesAutoresizingMaskIntoConstraints = false
        locationImage.image = UIImage(systemName: "location.fill")
        locationImage.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.preferredFont(forTextStyle: .body)
        locationLabel.textColor = .white
        locationLabel.numberOfLines = 1
        
        // Username
        usernameImage.translatesAutoresizingMaskIntoConstraints = false
        usernameImage.image = UIImage(systemName: "person.fill")
        usernameImage.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        usernameLabel.textColor = .white
        usernameLabel.numberOfLines = 1
        
        // Email
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        likeImage.image = UIImage(systemName: "heart.fill")
        likeImage.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)
        
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.font = UIFont.preferredFont(forTextStyle: .body)
        likeLabel.textColor = .white
        likeLabel.numberOfLines = 1
        
        // Photos
        photoImage.translatesAutoresizingMaskIntoConstraints = false
        photoImage.image = UIImage(systemName: "photo.fill")
        photoImage.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)
        
        photoLabel.translatesAutoresizingMaskIntoConstraints = false
        photoLabel.font = UIFont.preferredFont(forTextStyle: .body)
        photoLabel.textColor = .white
        photoLabel.numberOfLines = 1
        
        // Collections
        collectionImage.translatesAutoresizingMaskIntoConstraints = false
        collectionImage.image = UIImage(systemName: "photo.on.rectangle")
        collectionImage.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)
        
        collectionLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        collectionLabel.textColor = .white
        collectionLabel.numberOfLines = 1
        
        // Bio
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.font = UIFont.preferredFont(forTextStyle: .body)
        bioLabel.textColor = .white
        bioLabel.numberOfLines = 0
    }
    
    private func layoutProfile() {
        view.addSubview(titleLabel)
        view.addSubview(avatarImage)
        view.addSubview(locationImage)
        view.addSubview(locationLabel)
        view.addSubview(usernameImage)
        view.addSubview(usernameLabel)
        view.addSubview(likeImage)
        view.addSubview(likeLabel)
        view.addSubview(photoImage)
        view.addSubview(photoLabel)
        view.addSubview(collectionImage)
        view.addSubview(collectionLabel)
        view.addSubview(bioLabel)
        
        // Title
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 2),
        ])
        
        // ImageView
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            avatarImage.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            avatarImage.widthAnchor.constraint(equalToConstant: 100),
            avatarImage.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        // Location
        NSLayoutConstraint.activate([
            locationImage.topAnchor.constraint(equalTo: avatarImage.topAnchor),
            locationImage.leadingAnchor.constraint(equalToSystemSpacingAfter: avatarImage.trailingAnchor, multiplier: 1),
            locationImage.heightAnchor.constraint(equalToConstant: 15),
            locationImage.widthAnchor.constraint(equalToConstant: 15),
            
            locationLabel.centerYAnchor.constraint(equalTo: locationImage.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: locationImage.trailingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: locationLabel.trailingAnchor, multiplier: 2),
        ])
        
        // Username
        NSLayoutConstraint.activate([
            usernameImage.topAnchor.constraint(equalToSystemSpacingBelow: locationImage.bottomAnchor, multiplier: 2),
            usernameImage.leadingAnchor.constraint(equalToSystemSpacingAfter: avatarImage.trailingAnchor, multiplier: 1),
            usernameImage.heightAnchor.constraint(equalToConstant: 15),
            usernameImage.widthAnchor.constraint(equalToConstant: 15),
            
            usernameLabel.centerYAnchor.constraint(equalTo: usernameImage.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: usernameImage.trailingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: usernameLabel.trailingAnchor, multiplier: 2),
        ])
        
        // Likes
        NSLayoutConstraint.activate([
            likeImage.topAnchor.constraint(equalToSystemSpacingBelow: usernameImage.bottomAnchor, multiplier: 2),
            likeImage.leadingAnchor.constraint(equalToSystemSpacingAfter: avatarImage.trailingAnchor, multiplier: 1),
            likeImage.heightAnchor.constraint(equalToConstant: 15),
            likeImage.widthAnchor.constraint(equalToConstant: 15),
            
            likeLabel.centerYAnchor.constraint(equalTo: likeImage.centerYAnchor),
            likeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: usernameImage.trailingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: usernameLabel.trailingAnchor, multiplier: 2),
        ])
        
        // Photos
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalToSystemSpacingBelow: likeImage.bottomAnchor, multiplier: 2),
            photoImage.leadingAnchor.constraint(equalToSystemSpacingAfter: avatarImage.trailingAnchor, multiplier: 1),
            photoImage.heightAnchor.constraint(equalToConstant: 15),
            photoImage.widthAnchor.constraint(equalToConstant: 15),
            
            photoLabel.centerYAnchor.constraint(equalTo: photoImage.centerYAnchor),
            photoLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: likeImage.trailingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: likeLabel.trailingAnchor, multiplier: 2),
        ])
        
        // Collections
        NSLayoutConstraint.activate([
            collectionImage.topAnchor.constraint(equalToSystemSpacingBelow: photoImage.bottomAnchor, multiplier: 2),
            collectionImage.leadingAnchor.constraint(equalToSystemSpacingAfter: avatarImage.trailingAnchor, multiplier: 1),
            collectionImage.heightAnchor.constraint(equalToConstant: 15),
            collectionImage.widthAnchor.constraint(equalToConstant: 15),
            
            collectionLabel.centerYAnchor.constraint(equalTo: collectionImage.centerYAnchor),
            collectionLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: photoImage.trailingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: photoLabel.trailingAnchor, multiplier: 2),
        ])
        
        //Bio Label
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalToSystemSpacingBelow: avatarImage.bottomAnchor, multiplier: 2),
            bioLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: bioLabel.trailingAnchor, multiplier: 2),
        ])
    }
    
    private func checkProfile() {
        let token = try? keychain.get(accessTokenKey)
        if  let token = token {
            navigationController?.isNavigationBarHidden = false
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
            navigationController?.isNavigationBarHidden = true
            navigationController?.pushViewController(controller, animated: false)
        }
    }
}

extension ProfileViewController: LoginViewDelegate {
    
    func configureProfile(with profile: User) {
        // Avatar Image
        if let imageUrl = profile.profileImage?.large {
            self.avatarImage.kf.setImage(with: imageUrl)
        }
        // Title Label
        if let name = profile.name {
            titleLabel.text = "\(name)"
        }
        // Bio Label
        if let bio = profile.bio {
            bioLabel.text = "\(bio)"
        }
        // Location
        if let location = profile.location {
            locationLabel.text = "\(location)"
        }
        // Username
        if let username = profile.username {
            usernameLabel.text = "@\(username)"
        }
        // Likes
        if let likes = profile.totalLikes {
            likeLabel.text = "\(likes)"
        }
        // Photos
        if let photos = profile.totalPhotos {
            photoLabel.text = "\(photos)"
        }
        // Collections
        if let collection = profile.totalCollections {
            collectionLabel.text = "\(collection)"
        }
    }
}

// MARK: - Network
extension ProfileViewController {
    
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
        
        // Don't present one error if another has already been presented
        if !errorAlert.isBeingPresented {
            present(errorAlert, animated: true, completion: nil)
        }
    }
}

// MARK: - Actions
extension ProfileViewController {
    
    @objc func menuTapped(sender: UIButton) {
        showMenuAlert()
    }
    
    private func showMenuAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            self.settings()
        }
        settingsAction.setValue(UIColor.white, forKey: "titleTextColor")
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .default) { (_) in
            self.logOut()
        }
        logOutAction.setValue(UIColor.white, forKey: "titleTextColor")
        
        let canсelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        canсelAction.setValue(UIColor.white, forKey: "titleTextColor")
        
        alert.addAction(settingsAction)
        alert.addAction(logOutAction)
        alert.addAction(canсelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logOut(){
        try? keychain.remove(accessTokenKey)
        checkProfile()
    }
    
    private func settings(){
        let controller = SettingsViewController()
        controller.modalPresentationStyle = .currentContext
        controller.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(controller, animated: true)
    }
}
