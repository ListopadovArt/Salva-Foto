//
//  UIViewController+Utils.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit

extension UIViewController {
    
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
}
