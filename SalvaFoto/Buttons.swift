//
//  Buttons.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 6.08.22.
//

import Foundation
import UIKit

func makeButton(button: UIButton, scale: UIImage.SymbolScale = .large, systemName: String) {
    let configuration = UIImage.SymbolConfiguration(scale: scale)
    let saveImage = UIImage(systemName: systemName, withConfiguration: configuration)
    button.tintColor = .white
    button.setImage(saveImage, for: .normal)
}
