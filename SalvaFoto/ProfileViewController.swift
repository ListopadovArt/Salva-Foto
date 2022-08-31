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
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           
        ])
    }
}
