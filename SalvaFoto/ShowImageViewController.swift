//
//  ShowImageViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 5.08.22.
//

import UIKit
import Kingfisher
import SwiftyKeychainKit

class ShowImageViewController: UIViewController {
    
    var image: Photo!
    let itemImage = UIImageView()
    let headerView = UIView()
    let escapeButton = UIButton()
    let titleLabel = UILabel()
    let likeButton = UIButton()
    let saveButton = UIButton()
    
    // Keychain
    let keychain = Keychain(service: "storage")
    let accessTokenKey = KeychainKey<String>(key: "key")
    
    // Alert
    lazy var alert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    // Error alert
    lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchData()
        configure(model: image)
    }
    
    func configure(model: Photo){
        titleLabel.text = model.user?.name
        
        if let like = model.likedByUser {
            if like {
                makeButton(button: likeButton, systemName: "heart.fill")
                likeButton.isSelected = true
            } else {
                makeButton(button: likeButton, systemName: "heart")
                likeButton.isSelected = false
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        alert.title = title
        alert.message = message
        present(alert, animated: true, completion: nil)
    }
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Ensure you are connected to the internet. Please try again."
        }
        return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        
        present(errorAlert, animated: true, completion: nil)
    }
}

extension ShowImageViewController {
    private func style() {
        view.backgroundColor = .backgroundColor
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .backgroundColor
        
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
        likeButton.addTarget(self, action: #selector(likeTapped), for: .primaryActionTriggered)
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        makeButton(button: saveButton, systemName: "arrow.down.to.line.alt")
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
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            
            itemImage.trailingAnchor.constraint(equalToSystemSpacingAfter: saveButton.trailingAnchor, multiplier: 5),
            saveButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
}

// MARK: Actions
extension ShowImageViewController {
    @objc func escapeTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let token = try? keychain.get(accessTokenKey)
        if  let token = token {
            if sender.isSelected{
                makeButton(button: likeButton, systemName: "heart.fill")
                if let id = image.id {
                    ShowManager.shared.setLikeToPhoto(id: id, token: token, user: image.user!, photo: image) { result in
                        switch result {
                        case .success(let image):
//                            if let photo = image.photo {
                            self.image = image.photo
//                            }
                        case .failure(let error):
                            self.displayError(error)
                        }
                    }
                }
            }
            else{
                makeButton(button: likeButton, systemName: "heart")
                if let id = image.id {
                    ShowManager.shared.removeLikeFromPhoto(id: id, token: token)
                }
            }
        }
    }
    
    @objc func saveTapped() {
        if let image = itemImage.image {
            writeToPhotoAlbum(image: image)
        }
    }
}

//MARK: - Save photo
extension ShowImageViewController {
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error.localizedDescription)
            showAlert(title: "Error!", message: "Something went wrong. Try again.")
        } else {
            showAlert(title: "Success!", message: "Photo uploaded to gallery.")
        }
    }
}

// MARK: - Networking
extension ShowImageViewController {
    private func fetchData() {
        //TODO: - Implement image loading
        // https://unsplash.com/documentation#get-a-photo
    }
}
