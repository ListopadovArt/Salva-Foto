//
//  ShowImageViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 5.08.22.
//

import UIKit
import Kingfisher

class ShowImageViewController: UIViewController {
    
    var image: ImageData!
    let itemImage = UIImageView()
    let headerView = UIView()
    let escapeButton = UIButton()
    let titleLabel = UILabel()
    let likeButton = UIButton()
    let saveButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
}

extension ShowImageViewController {
    private func style() {
        view.backgroundColor = Colors.backgroundColor
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = Colors.backgroundColor
        
        escapeButton.translatesAutoresizingMaskIntoConstraints = false
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
        escapeButton.tintColor = .white
        escapeButton.setImage(image, for: .normal)
        escapeButton.addTarget(self, action: #selector(escapeTapped), for: .primaryActionTriggered)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .white
        
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        itemImage.contentMode = .scaleAspectFill
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        let likeConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let likeImage = UIImage(systemName: "heart.circle.fill", withConfiguration: likeConfiguration)
        likeButton.tintColor = .white
        likeButton.setImage(likeImage, for: .normal)
        likeButton.addTarget(self, action: #selector(likeTapped), for: .primaryActionTriggered)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let saveConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let saveImage = UIImage(systemName: "arrow.down.to.line.alt", withConfiguration: saveConfiguration)
        saveButton.tintColor = .white
        saveButton.setImage(saveImage, for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .primaryActionTriggered)
    }
    
    private func layout() {
        view.addSubview(headerView)
        view.addSubview(escapeButton)
        view.addSubview(titleLabel)
        view.addSubview(itemImage)
        view.addSubview(likeButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 40),
            
            escapeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            escapeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            escapeButton.heightAnchor.constraint(equalToConstant: 20),
            escapeButton.widthAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            
            itemImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            itemImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemImage.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            itemImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            likeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: itemImage.leadingAnchor, multiplier: 5),
            likeButton.bottomAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: -20),
            likeButton.heightAnchor.constraint(equalToConstant: 50),
            likeButton.widthAnchor.constraint(equalToConstant: 50),
            
            itemImage.trailingAnchor.constraint(equalToSystemSpacingAfter: saveButton.trailingAnchor, multiplier: 5),
            saveButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func configure(model: ImageData){
        let imageUrl = model.urls.small ?? ""
        if let url = URL(string: imageUrl) {
            itemImage.kf.setImage(with: url)
        }
        titleLabel.text = model.user?.name
    }
}

// MARK: Actions
extension ShowImageViewController {
    @objc func escapeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func likeTapped() {
        //TODO: - Calling the like function
        print("Like")
    }
    
    @objc func saveTapped() {
        //TODO: - Calling the save image function
        print("Save")
    }
}
