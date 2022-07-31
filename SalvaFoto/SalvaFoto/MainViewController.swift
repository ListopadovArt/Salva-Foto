//
//  ViewController.swift
//  SalvaFoto
//
//  Created by Artem Listopadov on 31.07.22.
//

import UIKit

let appColor: UIColor = UIColor(red: 0.86, green: 0.96, blue: 0.02, alpha: 1.00)

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
        tabBar.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        tabBar.tintColor = appColor
        tabBar.barTintColor = .systemGray
        tabBar.isTranslucent = true
    }
}





