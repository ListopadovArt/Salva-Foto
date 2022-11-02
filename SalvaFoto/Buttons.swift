//
//  Buttons.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 6.08.22.
//

import Foundation
import UIKit

func makeButton(button: UIButton, size: CGFloat = 30, systemName: String) {
    let configuration = UIImage.SymbolConfiguration(pointSize: size)
    let saveImage = UIImage(systemName: systemName, withConfiguration: configuration)
    button.tintColor = .appColor
    button.setImage(saveImage, for: .normal)
}
