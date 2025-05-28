//
//  TaskDetailsController.swift
//  TodoApp
//
//  Created by Marwa Awad on 15.03.2025.
//

import UIKit

class TaskDetailsController: UIViewController {

    private lazy var taskTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "task title label"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .purple
        view.addSubview(taskTitleLabel)
        
        NSLayoutConstraint.activate([
            taskTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            taskTitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
    }
}
