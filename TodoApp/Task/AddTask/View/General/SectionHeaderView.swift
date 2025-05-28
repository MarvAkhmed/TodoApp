//
//  SectionHeaderView.swift
//  TodoApp
//
//  Created by Marwa Awad on 26.03.2025.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - Identifier
    public static var identifier = "SectionHeaderView"
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: -  Initilizer
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("SectionHeaderView has no initializer")
    }

    //MARK: - Configure Section label
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    //MARK: - setup Layouts
    func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        ])
    }
}
