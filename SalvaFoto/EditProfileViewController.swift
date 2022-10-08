//
//  EditProfileViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 8.10.22.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension EditProfileViewController {
    func style() {
        view.backgroundColor = .backgroundColor
        
        // Label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.tintColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = "Welcome"
    }
    
    func layout() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
