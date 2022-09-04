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
    let imageView = UIImageView()
    let logOutButton = UIButton(type: .system)
    
    // Keychain
    let keychain = Keychain(service: "storage")
    let accessTokenKey = KeychainKey<String>(key: "key")
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    override func viewDidLoad() {
        style()
        checkProfile()
    }
}

extension ProfileViewController {
    private func style() {
        self.view.backgroundColor = .backgroundColor
        
        // Image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
        
        // Button
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.configuration = .filled()
        logOutButton.configuration?.imagePadding = 8
        logOutButton.setTitle("Log Out", for: [])
        logOutButton.addTarget(self, action: #selector(logOutTapped), for: .primaryActionTriggered)
        logOutButton.tintColor = .appColor
        logOutButton.setTitleColor(.black, for: .normal)
    }
    
    private func layoutProfile() {
        view.addSubview(imageView)
        view.addSubview(logOutButton)
        
        // ImageView
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        // LogOutButton
        NSLayoutConstraint.activate([
            logOutButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 5),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: logOutButton.trailingAnchor, multiplier: 5),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: logOutButton.bottomAnchor, multiplier: 10)
        ])
    }
    
    private func checkProfile() {
        let token = try? keychain.get(accessTokenKey)
        if  let token = token {
            let url = "https://api.unsplash.com/me?access_token=\(token)"
            ProfileManager.shared.fetchProfile(with: url) { result in
                switch result {
                case .success(let profile):
                    self.configureProfile(with: profile)
                    print(profile)
                case .failure(let error):
                    self.displayError(error)
                }
            }
        } else {
            let controller = LoginViewController()
            controller.modalPresentationStyle = .currentContext
            controller.modalTransitionStyle = .crossDissolve
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension ProfileViewController: LoginViewDelegate {
    
    func configureProfile(with profile: User) {
        self.layoutProfile()
        
        let imageUrl = profile.profileImage.small
        
        if let url = URL(string: imageUrl) {
            self.imageView.kf.setImage(with: url)
        }
    }
}

// Network
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
        
        present(errorAlert, animated: true, completion: nil)
    }
}

extension ProfileViewController {
    @objc func logOutTapped(sender: UIButton){
        try? keychain.removeAll()
        checkProfile()
    }
}
