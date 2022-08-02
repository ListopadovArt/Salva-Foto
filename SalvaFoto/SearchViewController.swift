//
//  SearchViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit

struct ImageData {
    let imageName: String
    let name: String
}

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.showsHorizontalScrollIndicator = false
        collection.alwaysBounceVertical = true
        collection.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    var imageArray = [ImageData(imageName: "Iam.png", name: "Artem"),
                      ImageData(imageName: "Iam.png", name: "Artem"),
                      ImageData(imageName: "Iam.png", name: "Artem"),
                      ImageData(imageName: "Iam.png", name: "Artem"),
    ]
    
    let accessKey = "f9U4wUpQbGa7KBTGQp-J8umBGGWBLaTJfiaKcOkBfn0"
    
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
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: searchBar.trailingAnchor, multiplier: 2),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        item.configure(with: imageArray[indexPath.item])
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 1) / 2
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
