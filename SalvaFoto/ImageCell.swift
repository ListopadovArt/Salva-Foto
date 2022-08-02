//
//  ImageCell.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 2.08.22.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    var itemImage = UIImageView()
    
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
    }
    
    private func layout() {
        contentView.addSubview(itemImage)
        
        NSLayoutConstraint.activate([
            itemImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            itemImage.topAnchor.constraint(equalTo: topAnchor),
            itemImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            itemImage.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension ImageCell {
    func configure(with model: ImageData) {
        let image = UIImage(named: model.imageName)
        itemImage.image = image
    }
}
