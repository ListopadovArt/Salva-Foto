//
//  ImageCell.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 2.08.22.
//

import UIKit
import Kingfisher

final class ImageCell: UICollectionViewCell {
    
    var itemImage = UIImageView()
    let nameLabel = UILabel()
    let likeImage = UIImageView()
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
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        nameLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        nameLabel.textColor = .white
        
        likeImage.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "heart.fill")
        likeImage.image = image
        likeImage.tintColor = .white
        
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.textAlignment = .left
        likesLabel.numberOfLines = 1
        likesLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        likesLabel.textColor = .white
    }
    
    private func layout() {
        contentView.addSubview(itemImage)
        contentView.addSubview(avatarImage)
        contentView.addSubview(likeImage)
        contentView.addSubview(likesLabel)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            itemImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImage.topAnchor.constraint(equalTo: topAnchor),
            itemImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            likeImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            likeImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            likeImage.heightAnchor.constraint(equalToConstant: 15),
            likeImage.widthAnchor.constraint(equalToConstant: 15),
            
            likesLabel.centerYAnchor.constraint(equalTo: likeImage.centerYAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likeImage.trailingAnchor, constant: 3),
            
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
    func configure(with model: Photo) {
        
        let url = model.urls?.small
        
        if let blur =  model.blurHash {
            let blurImage =  UIImage(blurHash: blur, size: CGSize(width: 32, height: 32))
            
            itemImage.kf.setImage(
                with: url,
                placeholder: blurImage,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        
        nameLabel.text = model.user?.name
        
        if let likes = model.likes {
            likesLabel.text = String(likes)
        }
        
        let image = UIImage(named: "user-placeholder")
        
        if let avatarUserUrl = model.user?.profileImage?.small {
            avatarImage.kf.indicatorType = .activity
            avatarImage.kf.setImage(with: avatarUserUrl, placeholder: image, options: [.transition(.fade(0.2))])
        }
    }
}
