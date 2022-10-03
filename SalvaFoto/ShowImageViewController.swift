//
//  ShowImageViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 5.08.22.
//

import UIKit
import Kingfisher
import SwiftyKeychainKit
import Loaf

class ShowImageViewController: UIViewController {
    
    var image: Photo!
    let itemImage = UIImageView()
    let headerView = UIView()
    let escapeButton = UIButton()
    let titleLabel = UILabel()
    let likeButton = UIButton()
    let saveButton = UIButton()
    let infoButton = UIButton()
    
    // Keychain
    private let keychain = Keychain(service: "storage")
    private let accessTokenKey = KeychainKey<String>(key: "key")
    
    // Alert
    private lazy var alert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    // Error alert
    private lazy var errorAlert: UIAlertController = {
        let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        fetchData(id: image.id!)
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
        
        let url = model.urls?.regular
        let blurImage =  UIImage(blurHash: model.blurHash!, size: CGSize(width: 32, height: 32))
        
        itemImage.kf.setImage(
            with: url,
            placeholder: blurImage,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
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
        
        // Don't present one error if another has already been presented
        if !errorAlert.isBeingPresented {
            present(errorAlert, animated: true, completion: nil)
        }
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
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        makeButton(button: infoButton, systemName: "info.circle")
        infoButton.addTarget(self, action: #selector(infoTapped), for: .primaryActionTriggered)
    }
    
    private func layout() {
        view.addSubview(headerView)
        view.addSubview(escapeButton)
        view.addSubview(titleLabel)
        view.addSubview(itemImage)
        view.addSubview(likeButton)
        view.addSubview(saveButton)
        view.addSubview(infoButton)
        
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
            
            infoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoButton.bottomAnchor.constraint(equalTo: likeButton.bottomAnchor),
            
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
                            self.image = image.photo
                        case .failure(let error):
                            self.displayError(error)
                        }
                    }
                }
            }
            else{
                makeButton(button: likeButton, systemName: "heart")
                if let id = image.id {
                    ShowManager.shared.removeLikeFromPhoto(id: id, token: token) { result in
                        switch result {
                        case .success(let image):
                            self.image = image.photo
                        case .failure(let error):
                            self.displayError(error)
                        }
                    }
                }
            }
        }
    }
    
    @objc func saveTapped() {
        if let imageString = image.urls?.regular {
            saveImage(url: imageString)
        }
    }
    
    @objc func infoTapped() {
        let sheetViewController = InformPhotoViewController()
        if let sheet = sheetViewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 32
        }
        sheetViewController.configure(image: image)
        present(sheetViewController, animated: true)
    }
}

//MARK: - Save photo
extension ShowImageViewController {
    
    private func saveImage(url: URL) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            let savedImage = UIImage(data: data!)
            DispatchQueue.main.async {
                UIImageWriteToSavedPhotosAlbum(savedImage!, nil, nil, nil)
                Loaf("Image successfully saved to your photos!", state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
            }
        }
    }
}

// MARK: - Networking
extension ShowImageViewController {
    private func fetchData(id: String) {
        
        let token = try? keychain.get(accessTokenKey)
        if let token = token {
            
            ShowManager.shared.getPhoto(id: id, token: token) { result in
                switch result {
                case .success(let image):
                    self.configure(model: image)
                    self.likeButton.isHidden = false
                case .failure(let error):
                    self.displayError(error)
                }
            }
        } else {
            self.configure(model: self.image)
            likeButton.isHidden = true
        }
    }
}
