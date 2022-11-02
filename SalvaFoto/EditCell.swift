//
//  EditCell.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 8.10.22.
//


import UIKit

enum TextFieldData: Int {
    case firstName = 0
    case lastName = 1
    case username = 2
    case email = 3
    case location = 4
}

class EditCell: UITableViewCell {
    
    let titleTextField = UITextField()
    
    static let reuseID = "EditCell"
    static let rowHeight:CGFloat = 44
    
    var placeholder: String? {
        didSet {
            guard let item = placeholder else {return}
            titleTextField.placeholder = item
        }
    }
    
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
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.textColor = .white
        titleTextField.delegate = self
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter your text",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.backgroundColor]
        )
    }
    
    private func layout() {
        contentView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 3),
            titleTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: titleTextField.trailingAnchor, multiplier: 3),
        ])
    }
}

//MARK: - UITextFieldDelegate
extension EditCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}


