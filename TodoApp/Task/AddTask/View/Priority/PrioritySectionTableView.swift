//
//  PriorityTableViewCell.swift
//  TodoApp
//
//  Created by Marwa Awad on 08.05.2025.
//

import UIKit

class PrioritySectionTableView: UITableViewCell {
    
    //MARK: - Identifier
    public static let reuseIdentifier = "PrioritySectionTableViewCell"
    private let addTaskViewModel = AddTasksViewModel.shared
    
    var taskId: UUID?
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.register(PriorityCollectionViewCell.self, forCellWithReuseIdentifier: PriorityCollectionViewCell.reuseIdentifier)
        cv.dataSource = self
        cv.delegate = self
        cv.isScrollEnabled = false
        cv.isUserInteractionEnabled = true
        cv.allowsSelection = true
        return cv
    }()
    
    // MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            collectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension PrioritySectionTableView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        addTaskViewModel.getPrioreties().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PriorityCollectionViewCell.reuseIdentifier, for: indexPath) as?
                PriorityCollectionViewCell else { fatalError("Unable to dequeue PriorityCollectionViewCell")     }
        let item = addTaskViewModel.getPrioreties()[ indexPath.item]
        let taskId = addTaskViewModel.currentTaskId
        let isSelected = addTaskViewModel.isSelected(at: indexPath.row, for: taskId)
        cell.configure(with: item, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let taskId = addTaskViewModel.currentTaskId
        addTaskViewModel.toggleSelection(at: indexPath.row, for: taskId)
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PrioritySectionTableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.width - 32
        let spacingBetweenItems: CGFloat = 16
        let availableWidth = totalWidth - (spacingBetweenItems * CGFloat(addTaskViewModel.getPrioreties().count - 1))
        let itemWidth = availableWidth / CGFloat(addTaskViewModel.getPrioreties().count)
        
        let cellSize = min(itemWidth, 80)
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

