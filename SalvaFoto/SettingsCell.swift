//
//  SettingsCell.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 2.10.22.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let titleImage = UIImageView()
    let titleLabel = UILabel()
    let chevronImageView = UIImageView()
    
    static let reuseID = "SettingsCell"
    static let rowHeight:CGFloat = 44
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsCell {
    
    private func setup() {
        // Image
        titleImage.clipsToBounds = true
        titleImage.contentMode = .scaleAspectFit
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.tintColor = UIColor.white
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
        
        // Chevron
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        let chevronImage = UIImage(systemName: "chevron.right")?.withTintColor(.appColor, renderingMode: .alwaysOriginal)
        chevronImageView.image = chevronImage
    }
    
    private func layout() {
        contentView.addSubview(titleImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            titleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleImage.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            titleImage.widthAnchor.constraint(equalToConstant: 24),
            titleImage.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: titleImage.trailingAnchor, multiplier: 1),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 3)
        ])
    }
}


