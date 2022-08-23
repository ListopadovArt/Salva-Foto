//
//  ImageCell.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 2.08.22.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell {
    
    var itemImage = UIImageView()
    let nameLabel = UILabel()
    let likeButton = UIButton()
    let likesLabel = UILabel()
    var avatarImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageCell {
    
    private func setup() {
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        itemImage.contentMode = .scaleAspectFill
        itemImage.clipsToBounds = true
        itemImage.layer.cornerRadius = 5
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clipsToBounds = true
        avatarImage.layer.cornerRadius = 10
        avatarImage.backgroundColor = .red
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        nameLabel.textColor = .white
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        makeButton(button: likeButton, systemName: "heart")
        likeButton.addTarget(self, action: #selector(likeTapped), for: .primaryActionTriggered)
        
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.textAlignment = .left
        likesLabel.numberOfLines = 1
        likesLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        likesLabel.textColor = .white
    }
    
    private func layout() {
        contentView.addSubview(itemImage)
        contentView.addSubview(avatarImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(likesLabel)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            itemImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImage.topAnchor.constraint(equalTo: topAnchor),
            itemImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            likeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            likeButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            likesLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 3),
            
            avatarImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            avatarImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            avatarImage.heightAnchor.constraint(equalToConstant: 20),
            avatarImage.widthAnchor.constraint(equalToConstant: 20),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}

extension ImageCell {
    func configure(with model: ImageData) {
        let imageUrl = model.urls.small
        
        if let url = URL(string: imageUrl) {
            if itemImage.image == nil {
                if let blur = model.blurHash {
                    let blurImage =  UIImage(blurHash: blur, size: CGSize(width: 32, height: 32))
                    itemImage.image = blurImage
                }
            } else {
                itemImage.kf.setImage(with: url)
            }
        }
        
        nameLabel.text = model.user?.name
        
        if let likes = model.likes {
            likesLabel.text = String(likes)
        }
        
        if let avatarUserUrl = model.user?.profileImage.small {
            if let url = URL(string: avatarUserUrl) {
                avatarImage.kf.setImage(with: url)
            }
        }
    }
}

// MARK: Actions
extension ImageCell {
    @objc func likeTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            makeButton(button: likeButton, systemName: "heart.fill")
        }
        else{
            makeButton(button: likeButton, systemName: "heart")
        }
    }
}
