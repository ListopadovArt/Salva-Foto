//
//  ProfileViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit
import SwiftyKeychainKit

class ProfileViewController: UIViewController {
    
    // Profile
    let profile: User? = nil
    let imageView = UIImageView()
    
    // Keychain
    let keychain = Keychain(service: "storage")
    let accessTokenKey = KeychainKey<String>(key: "key")
    
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
        imageView.backgroundColor = .green
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 100
    }
    
    private func layoutProfile() {
        view.addSubview(imageView)
        
        // ImageView
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

extension ProfileViewController: LoginViewDelegate {
    func getProfile(profile: User) {
        configureProfile(with: profile)
    }
    
    func checkProfile() {
        let token = try? keychain.get(accessTokenKey)
        if  let token = token {
            let url = "https://api.unsplash.com/me?access_token=\(token)"
            ProfileManager.shared.fetchProfile(with: url) { result in
                switch result {
                case .success(let profile):
                    self.layoutProfile()
                    self.getProfile(profile: profile)
                    print(profile)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            let controller = LoginViewController()
            controller.modalPresentationStyle = .currentContext
            controller.modalTransitionStyle = .crossDissolve
            controller.delegate = self
            self.present(controller,animated: true, completion: nil)
        }
    }
    
    func configureProfile(with profile: User) {
        
        //TODO: - Configure Profile
        
    }
}
