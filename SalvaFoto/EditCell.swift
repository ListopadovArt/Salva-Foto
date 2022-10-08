//
//  EditCell.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 8.10.22.
//


import UIKit

class EditCell: UITableViewCell {
    
    let titleLabel = UILabel()
    
    static let reuseID = "EditCell"
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

extension EditCell {
    
    private func setup() {
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left
    }
    
    private func layout() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 3),
        ])
    }
}



