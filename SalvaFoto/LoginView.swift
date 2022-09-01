//
//  LoginView.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 30.08.22.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    func getProfile(profile: User)
}

class LoginView: UIView {
    
    let titleLabel = UILabel()
    let signButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    
    weak var delegate: LoginViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginView {
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        clipsToBounds = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 1
        titleLabel.text = "Login to Unsplash"
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
        addSubview(titleLabel)
        addSubview(signButton)
        addSubview(errorMessageLabel)
        
        // Title
        NSLayoutConstraint.activate([
            signButton.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 5),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 5),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 5),
        ])
        
        // SignButton
        NSLayoutConstraint.activate([
            signButton.centerYAnchor.constraint(equalTo: centerYAnchor),
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

extension LoginView {
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
                
                //TODO: - Save token (accessTokenResponse.accessToken) in KeyChain
                
                let url = "https://api.unsplash.com/me?access_token=\(accessTokenResponse.accessToken)"
                ProfileManager.shared.fetchProfile(with: url) { result in
                    switch result {
                    case .success(let profile):
                        self.isHidden = true
                        self.delegate?.getProfile(profile: profile)
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
}
