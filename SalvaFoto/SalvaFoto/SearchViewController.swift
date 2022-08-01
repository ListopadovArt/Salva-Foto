//
//  SearchViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        style()
        layout()
    }
}

extension SearchViewController {
    
    private func style() {
        view.backgroundColor = Colors.backgroundColor
        self.navigationController?.isNavigationBarHidden = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.backgroundColor = UIColor(red: 0.19, green: 0.19, blue: 0.22, alpha: 1.00)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.leftView?.tintColor = UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [.foregroundColor: UIColor(red: 0.56, green: 0.56, blue: 0.60, alpha: 1.00)]
        )
        searchBar.barTintColor = Colors.backgroundColor
        searchBar.delegate = self
        searchBar.layer.cornerRadius = 5
        searchBar.clipsToBounds = true
    }
    
    private func layout() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchBar.trailingAnchor, multiplier: 2),
        ])
    }
}

extension SearchViewController: UISearchBarDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
