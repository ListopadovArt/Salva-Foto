//
//  LoginView.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 30.08.22.
//

import UIKit
import SwiftyKeychainKit

protocol LoginViewDelegate: AnyObject {
    func configureProfile(with profile: User)
}

class LoginViewController: UIViewController {
    
    // Keychain
    let keychain = Keychain(service: "storage")
    let accessTokenKey = KeychainKey<String>(key: "key")
    
    let titleLabel = UILabel()
    let signButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    
    weak var delegate: LoginViewDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authorizationVerification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension LoginViewController {
    func style() {
        self.view.backgroundColor = .backgroundColor
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 1
        titleLabel.text = "Login by Unsplash"
        titleLabel.textColor = .white
        
        signButton.translatesAutoresizingMaskIntoConstraints = false
        signButton.configuration = .filled()
        signButton.configuration?.imagePadding = 8
        signButton.setTitle("Sign In", for: [])
        signButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        signButton.tintColor = .appColor
        signButton.setTitleColor(.black, for: .normal)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.text = ""
    }
    
    func layout() {
        view.addSubview(titleLabel)
        view.addSubview(signButton)
        view.addSubview(errorMessageLabel)
        
        // Title
        NSLayoutConstraint.activate([
            signButton.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 5),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 5),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 5),
        ])
        
        // SignButton
        NSLayoutConstraint.activate([
            signButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            signButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            signButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
        
        // ErrorLabel
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signButton.bottomAnchor, multiplier: 3),
            errorMessageLabel.leadingAnchor.constraint(equalTo: signButton.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: signButton.trailingAnchor)
        ])
    }
}

extension LoginViewController {
    @objc func signInTapped(sender: UIButton){
        login()
    }
    
    private func login() {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let host = "https://unsplash.com"
        let authorizeURL = "\(host)/oauth/authorize"
        let tokenURL = "\(host)/oauth/token"
        let clientId = "f9U4wUpQbGa7KBTGQp-J8umBGGWBLaTJfiaKcOkBfn0"
        let clientSecret = "7FHZh8Q_0E0B19tj8X6ywRYRzQFEdOFtC4sDgzmBook"
        let redirectUri = "\(bundleIdentifier)://localhost/redirect"
        
        let parameters = OAuthParameters(authorizeUrl: authorizeURL,
                                         tokenUrl:tokenURL,
                                         clientId: clientId,
                                         clientSecret: clientSecret,
                                         redirectUri: redirectUri,
                                         callbackURLScheme: bundleIdentifier)
        
        authorization(parameters: parameters)
    }
    
    private func authorization(parameters: OAuthParameters){
        let authenticator = Authenticator()
        authenticator.authenticate(parameters: parameters) { result in
            var message: String = ""
            switch result {
            case .success(let accessTokenResponse):
                //Save token in KeyChain
                try? self.keychain.set(accessTokenResponse.accessToken, for : self.accessTokenKey)
                
                let url = "https://api.unsplash.com/me?access_token=\(accessTokenResponse.accessToken)"
                ProfileManager.shared.fetchProfile(with: url) { result in
                    switch result {
                    case .success(let profile):
                        self.navigationController?.popViewController(animated: false)
                        self.delegate?.configureProfile(with: profile)
                    case .failure(let error):
                        message = error.localizedDescription
                        self.errorMessageLabel.text = message
                    }
                }
            case .failure(let error):
                message = error.localizedDescription
            }
            DispatchQueue.main.async {
                self.errorMessageLabel.text = message
            }
        }
    }
    
    private func authorizationVerification(){
        let token = try? keychain.get(accessTokenKey)
        if  let token = token {
            let url = "https://api.unsplash.com/me?access_token=\(token)"
            ProfileManager.shared.fetchProfile(with: url) { result in
                switch result {
                case .success(let profile):
                    self.navigationController?.popViewController(animated: false)
                    self.delegate?.configureProfile(with: profile)
                case .failure(let error):
                    let message = error.localizedDescription
                    self.errorMessageLabel.text = message
                }
            }
        }
    }
}
