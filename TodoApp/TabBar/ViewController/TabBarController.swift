//
//  Vc.swift
//  TodoApp
//
//  Created by Marwa Awad on 10.03.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        customizeTabBar()
    }
    
    private func setupTabs() {
        viewControllers = TabBarModel.allCases.map { tab in
            let viewController = tab.viewController
            let navController = UINavigationController(rootViewController: viewController)
            navController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: tab.image,
                tag: tab.rawValue
            )
            navController.tabBarItem.accessibilityLabel = tab.title
            navController.tabBarItem.accessibilityIdentifier = "\(tab.title)Tab"
            navController.navigationBar.prefersLargeTitles = true
            return navController
        }
    }
    
    private func customizeTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.unselectedItemTintColor = .systemGray
    }
}
