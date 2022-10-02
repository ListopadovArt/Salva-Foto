//
//  SettingsViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 2.10.22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let stackView = UIStackView()
    let label = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        self.navigationItem.backButtonTitle = ""
        
    }
    
    @objc func backTapped(sender: UIButton) {
        //TODO: - Add Info button functionality
    }
}

extension SettingsViewController {
    func style() {
        self.view.backgroundColor = .backgroundColor
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        // Label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.text = "Welcome"
        label.textColor = .white
    }
    
    func layout() {
        stackView.addArrangedSubview(label)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
    }
}
