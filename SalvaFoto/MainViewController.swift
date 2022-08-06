//
//  ViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTabBar()
    }
    
    private func setupViews() {
        let searchVC = SearchViewController()
        let favoriteVC = FavoriteViewController()
        let profileVC = ProfileViewController()
        
        searchVC.setTabBarImage(imageName: "magnifyingglass", title: "Search")
        favoriteVC.setTabBarImage(imageName: "heart.fill", title: "Favorite")
        profileVC.setTabBarImage(imageName: "person.crop.circle", title: "Profile")
        
        let summaryNC = UINavigationController(rootViewController: searchVC)
        let moneyNC = UINavigationController(rootViewController: favoriteVC)
        let moreNC = UINavigationController(rootViewController: profileVC)
        
        let tabBarList = [summaryNC, moneyNC, moreNC]
        
        viewControllers = tabBarList
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .backgroundColor
        tabBar.tintColor = .appColor
        tabBar.barTintColor = .systemGray
        tabBar.isTranslucent = true
    }
}





