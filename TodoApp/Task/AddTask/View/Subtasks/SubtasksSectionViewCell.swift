//
//  SubtasksSectionViewCell.swift
//  TodoApp
//
//  Created by Marwa Awad on 01.04.2025.
//

import UIKit
import Combine

protocol TaskTitleTrace: AnyObject {
    func getCurrentTaskTitle() -> String
}

protocol SubtasksSectionViewCellDelegate: AnyObject {
    func didTapSubtasksCell()
}



class SubtasksSectionViewCell: UITableViewCell {
    
    //MARK: - Identifier
    static let identifier = "SubtasksSectionViewCell"
    weak var titleTextTracer: TaskTitleTrace?
    weak var delegate: SubtasksSectionViewCellDelegate?

    //MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    let addSubtaskViewModel =  AddSubtaskViewModel.shared
    
    var subtasksCount: Int {
        return addSubtaskViewModel.getSubtasksCount()
    }
    
    //MARK: - UI Components
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.backgroundColor = .clear
        label.text = "Error"
        return label
    }()
    
    private lazy var cellButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.addTarget(self, action: #selector(didMoveToAddSubtask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBlue
        return button
    }()
    
    private lazy var CounterHStackView: UIStackView =  {
        let sv = UIStackView(arrangedSubviews: [counterLabel, cellButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 10
        return sv
    }()
    
    //MARK: - Initilizer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupUI()
        addTapGesture()
        setupObserver()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
     
    // MARK: - Move to add Subtasks
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
    }
    //MARK: - subscripe to the counter label
    private func setupObserver() {
        addSubtaskViewModel.$subtasks
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.counterLabel.text = "\(self?.subtasksCount ?? 0)"
            }
            .store(in: &cancellables)
    }
    
    func updateUILabel(_ tableView: UITableView) {
        DispatchQueue.main.async {
            self.counterLabel.text = "\(self.subtasksCount)"
        }
    }
    
    
    @objc private func didMoveToAddSubtask() {
        delegate?.didTapSubtasksCell()
    }
    
    @objc private func viewTapped() {
        delegate?.didTapSubtasksCell()
    }

    //MARK: - setup Layouts
    func setupUI() {
        counterLabel.text = "\(subtasksCount)"
        contentView.addSubview(CounterHStackView)
        NSLayoutConstraint.activate([
            CounterHStackView.centerYAnchor.constraint(equalTo: contentView.layoutMarginsGuide.centerYAnchor),
            CounterHStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
        ])
    }
}
