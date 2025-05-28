//
//  UIManager.swift
//  TodoApp
//
//  Created by Marwa Awad on 25.03.2025.
//


import UIKit

class AddTaskUIManager {
    private weak var viewController: AddTaskViewController?
    
    init(viewController: AddTaskViewController) {
        self.viewController = viewController
    }

    //MARK: - Default View
    func setupDefaultUI() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        
        vc.view.addSubview(vc.upperContentViewWithoutTable)
        vc.upperContentViewWithoutTable.addSubview(vc.taskTitleTextField)
        vc.upperContentViewWithoutTable.addSubview(vc.taskSectionHStackView)
        
        vc.upperContentViewWithTable.isHidden = true
        if !vc.propertyTableView.isHidden {
            vc.propertyTableView.removeFromSuperview()
        }
        vc.view.addSubview(vc.propertyTableView)
        
        applyDefaultConstraints()
    }
    
    //MARK: - Default Constraints
    private func applyDefaultConstraints() {
        guard let vc = viewController else { return }
        NSLayoutConstraint.activate([
            vc.upperContentViewWithoutTable.topAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.topAnchor),
            vc.upperContentViewWithoutTable.leadingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.leadingAnchor),
            vc.upperContentViewWithoutTable.trailingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.trailingAnchor),
            vc.upperContentViewWithoutTable.heightAnchor.constraint(equalToConstant: 100),
            
            vc.taskTitleTextField.topAnchor.constraint(equalTo: vc.upperContentViewWithoutTable.topAnchor, constant: 10),
            vc.taskTitleTextField.leadingAnchor.constraint(equalTo: vc.upperContentViewWithoutTable.leadingAnchor),
            vc.taskTitleTextField.trailingAnchor.constraint(equalTo: vc.upperContentViewWithoutTable.trailingAnchor),
            
            vc.taskSectionHStackView.topAnchor.constraint(equalTo: vc.taskTitleTextField.bottomAnchor, constant: 10),
            vc.taskSectionHStackView.leadingAnchor.constraint(equalTo: vc.upperContentViewWithoutTable.leadingAnchor),
            vc.taskSectionHStackView.trailingAnchor.constraint(equalTo: vc.upperContentViewWithoutTable.trailingAnchor),
            
            vc.propertyTableView.topAnchor.constraint(equalTo: vc.taskSectionHStackView.bottomAnchor, constant: 20),
            vc.propertyTableView.leadingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.leadingAnchor),
            vc.propertyTableView.trailingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.trailingAnchor),
            vc.propertyTableView.bottomAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    //MARK: - Expanded View
    func setupExpandedTypeUI() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        
        vc.view.addSubview(vc.upperContentViewWithTable)
        vc.upperContentViewWithTable.isHidden = false
        vc.upperContentViewWithTable.addSubview(vc.taskTitleTextField)
        vc.upperContentViewWithTable.addSubview(vc.taskSectionHStackView)
        vc.upperContentViewWithTable.addSubview(vc.taskSectionsTableView)
        
        vc.propertyTableView.removeFromSuperview()
        vc.view.addSubview(vc.propertyTableView)
        
        applyExpandedConstraints()
    }
    
    //MARK: - Expanded Constraints
    private func applyExpandedConstraints() {
        guard let vc = viewController else { return }
        NSLayoutConstraint.activate([
            vc.upperContentViewWithTable.topAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.topAnchor),
            vc.upperContentViewWithTable.leadingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.leadingAnchor),
            vc.upperContentViewWithTable.trailingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.trailingAnchor),
            vc.upperContentViewWithTable.heightAnchor.constraint(equalToConstant: 240),
            
            vc.taskTitleTextField.topAnchor.constraint(equalTo: vc.upperContentViewWithTable.topAnchor, constant: 10),
            vc.taskTitleTextField.leadingAnchor.constraint(equalTo: vc.upperContentViewWithTable.leadingAnchor),
            vc.taskTitleTextField.trailingAnchor.constraint(equalTo: vc.upperContentViewWithTable.trailingAnchor),
            
            vc.taskSectionHStackView.topAnchor.constraint(equalTo: vc.taskTitleTextField.bottomAnchor, constant: 10),
            vc.taskSectionHStackView.leadingAnchor.constraint(equalTo: vc.upperContentViewWithTable.leadingAnchor),
            vc.taskSectionHStackView.trailingAnchor.constraint(equalTo: vc.upperContentViewWithTable.trailingAnchor),
            
            vc.taskSectionsTableView.topAnchor.constraint(equalTo: vc.taskSectionHStackView.bottomAnchor, constant: 10),
            vc.taskSectionsTableView.leadingAnchor.constraint(equalTo: vc.upperContentViewWithTable.leadingAnchor),
            vc.taskSectionsTableView.trailingAnchor.constraint(equalTo: vc.upperContentViewWithTable.trailingAnchor),
            vc.taskSectionsTableView.bottomAnchor.constraint(equalTo: vc.upperContentViewWithTable.bottomAnchor),
            
            vc.propertyTableView.topAnchor.constraint(equalTo: vc.taskSectionsTableView.bottomAnchor, constant: 20),
            vc.propertyTableView.leadingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.leadingAnchor),
            vc.propertyTableView.trailingAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.trailingAnchor),
            vc.propertyTableView.bottomAnchor.constraint(equalTo: vc.view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    // MARK: - UI Updates Logic
    /// Updates the button's arrow direction.
    /// - Parameters:
    ///   - button: UIButton to be updated
    ///   - direction: The SF Symbol name for the desired arrow direction
    func updateArrowDirection(_ button: UIButton, to direction: String) {
        DispatchQueue.main.async {
            button.setImage(UIImage(systemName: direction), for: .normal)
        }
    }
    
    /// Changes the arrow direction to downward.
    func setArrowDown(_ button: UIButton) {
        updateArrowDirection(button, to: "chevron.down")
    }
    
    /// Changes the arrow direction to left.
    func setArrowLeft(_ button: UIButton) {
        updateArrowDirection(button, to: "chevron.backward")
    }
}

extension UIView {
    func apply(_ completion: (UIView) -> Void) -> UIView {
        completion(self)
        return self
    }
}
