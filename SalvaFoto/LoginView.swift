//
//  LoginView.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 30.08.22.
//

import UIKit

class LoginView: UIView {
    
    let titleLabel = UILabel()
    let signButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    
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
        //        errorMessageLabel.isHidden = true
        errorMessageLabel.text = "Error example..."
        
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
        // errorMessageLabel.isHidden = true
        login()
    }
    
    private func login() {
        print("Login")
    }
}
