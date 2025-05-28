//
//  TapbarController.swift
//  TodoApp
//
//  Created by Marwa Awad on 10.03.2025.
//
//

import UIKit

enum TabBarModel: Int, CaseIterable {
    case tasks
    case dashboard
    case settings
    
    var title: String {
        switch self {
        case .tasks: return "Tasks"
        case .dashboard: return "Dashboard"
        case .settings: return "Settings"
        }
    }
    
    var image: UIImage? {
        let imageName: String
        switch self {
        case .tasks: imageName = "list.bullet"
        case .dashboard: imageName = "chart.bar"
        case .settings: imageName = "gear"
        }
        
        let image = UIImage(systemName: imageName)
        return image
    }
    
    var viewController: UIViewController {
        switch self {
        case .tasks: return TasksViewController()
        case .dashboard: return DashboardViewController()
        case .settings: return SettingsViewController()
        }
    }
}

