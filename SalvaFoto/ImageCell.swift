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
    let nameView = UIView()
    let nameLabel = UILabel()
    let likeButton = UIButton()
    let likesLabel = UILabel()

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
        
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.alpha = 0.5
        nameView.backgroundColor = .backViewColor
        nameView.layer.cornerRadius = 5
        nameView.clipsToBounds = true
        
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
        contentView.addSubview(likeButton)
        contentView.addSubview(likesLabel)
        contentView.addSubview(nameView)
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
            
            nameView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nameView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            nameView.heightAnchor.constraint(equalToConstant: 20),
            
            nameLabel.centerYAnchor.constraint(equalTo: nameView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 5),
        ])
    }
}

extension ImageCell {
    func configure(with model: ImageData) {
        let imageUrl = model.urls.small
        
        if let url = URL(string: imageUrl) {
            itemImage.kf.setImage(with: url)
        }
        nameLabel.text = model.user?.name
        
        if let likes = model.likes {
            likesLabel.text = String(likes)
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
