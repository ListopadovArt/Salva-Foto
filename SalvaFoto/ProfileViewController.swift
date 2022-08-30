//
//  ProfileViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let loginView = LoginView()
    
    override func viewDidLoad() {
        style()
        layout()
    }
}

extension ProfileViewController {
    private func style() {
        self.view.backgroundColor = .backgroundColor
    }
    
    private func layout() {
        view.addSubview(loginView)
        
        // LoginView
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginView.heightAnchor.constraint(equalToConstant: 300),
            loginView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}
