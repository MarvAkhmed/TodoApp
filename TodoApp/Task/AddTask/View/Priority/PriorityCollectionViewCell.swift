//
//  PriorityCellView.swift
//  TodoApp
//
//  Created by Marwa Awad on 08.05.2025.
//

import UIKit

class PriorityCollectionViewCell: UICollectionViewCell {
    //MARK: - Identifier
    public static let reuseIdentifier = "PriorityCellView"
    private let viewModel = AddTasksViewModel.shared
    
    private var currentPriority: PriorityItem?
    
    //MARK: -  UI Components
    lazy var customView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 40
        view.layer.borderWidth = 2.0
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error"
        label.textColor = .black
        return label
    }()
    
    //MARK: - collectionView Cell config
    func configure(with priority: PriorityItem, isSelected: Bool) {
        currentPriority = priority
        titleLabel.text = priority.title
        customView.layer.borderColor = priority.color.cgColor
        customView.backgroundColor = isSelected ? priority.color.withAlphaComponent(0.7) : .clear
    }
    
    //MARK: - Initlizer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout Constraints
    private func setupUI() {
        contentView.addSubview(customView)
        customView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            customView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            customView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1),
            
            titleLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
        ])
    }
}

