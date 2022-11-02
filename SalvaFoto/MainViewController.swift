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
        setupNavBar()
    }
    
    private func setupViews() {
        let searchVC = SearchViewController()
        let favoriteVC = FavoriteViewController()
        let profileVC = ProfileViewController()
        
        searchVC.setTabBarImage(imageName: "magnifyingglass", title: "Search")
        favoriteVC.setTabBarImage(imageName: "heart.fill", title: "Favorite")
        profileVC.setTabBarImage(imageName: "person.crop.circle", title: "Profile")
        
        let searchNC = UINavigationController(rootViewController: searchVC)
        let favoriteNC = UINavigationController(rootViewController: favoriteVC)
        let profileNC = UINavigationController(rootViewController: profileVC)
        
        let tabBarList = [searchNC, favoriteNC, profileNC]
        
        viewControllers = tabBarList
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .appColor
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .backgroundColor
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        } else {
            tabBar.backgroundColor = .backgroundColor
            tabBar.barTintColor = .backgroundColor
            tabBar.isTranslucent = false
        }
    }
    
    private func setupNavBar() {
        let appearance =  UIBarButtonItem.appearance()
        appearance.tintColor = .white
    }
}





