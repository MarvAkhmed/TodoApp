//
//  DashboardViewController.swift
//  TodoApp
//
//  Created by Marwa Awad on 10.03.2025.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Dashboard"
        view.backgroundColor = .white
        
    }
}
