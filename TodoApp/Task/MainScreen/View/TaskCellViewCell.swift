//
//  TaskCellView.swift
//  TodoApp
//
//  Created by Marwa Awad on 11.03.2025.
//

import UIKit

class TaskCellViewCell: UITableViewCell {
    
    //MARK: Variabels
    static let identifier = "TaskCellViewCell"
    
    //MARK: - UI Components
    private lazy var markAsDoneView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var completeTaskButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var taskNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timerPrefixLabel: UILabel = {
        let label = UILabel()
        label.text = "Timer:"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var taskTimerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timerPrefixLabel, taskTimerLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var nextTaskPrefixLabel: UILabel = {
        let label = UILabel()
        label.text = "Next Task:"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var nextSubtaskLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nextSubTaskStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nextTaskPrefixLabel, nextSubtaskLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var completedSubtasksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var taskProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .systemBlue
        progressView.trackTintColor = .systemGray6
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        return progressView
    }()
    
    
    private lazy var completionPercentageLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    private lazy var warningIconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "exclamationmark.triangle")
        image.tintColor = .systemYellow
        return image
    }()
    
    private var aiSuggestionImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "lightbulb.circle")
        image.tintColor = .systemTeal
        return image
    }()
    
    private lazy var delayStatusIndicatorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Cell Configuraion
    public func configure(with task: TaskModel) {
        self.taskNameLabel.text = task.taskTitle
        // add task section (this will be the section of the table view) taken from the section type
        self.taskTimerLabel.text = task.deadline.timeIntervalSince1970.description
//        let subTasksPreview = task.subTasks?.first
        self.completedSubtasksLabel.text = "\(task.numberOfCompletedSubtasks)/\(task.numberOfSubtasks) completed"
        self.taskProgressView.progress = Float(task.percentageCompletion) / 100.0
        self.completionPercentageLabel.text = "\(task.percentageCompletion)%"
        self.completeTaskButton.isSelected = task.isCompleted
        self.aiSuggestionImageView.isHidden = (task.AISuggestion == nil)
    }
    
    //MARK: - Initilizer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .white
        contentView.addSubview(markAsDoneView)
        markAsDoneView.addSubview(completeTaskButton)
        contentView.addSubview(taskNameLabel)
        contentView.addSubview(timerStackView)
        contentView.addSubview(nextSubTaskStackView)
        contentView.addSubview(completedSubtasksLabel)
        contentView.addSubview(completionPercentageLabel)
        contentView.addSubview(taskProgressView)
        contentView.addSubview(delayStatusIndicatorView)
        contentView.addSubview(warningIconImageView)
        contentView.addSubview(aiSuggestionImageView)
       
        NSLayoutConstraint.activate([
            
            markAsDoneView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            markAsDoneView.widthAnchor.constraint(equalToConstant: 44),
            markAsDoneView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            markAsDoneView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

            completeTaskButton.topAnchor.constraint(equalTo: markAsDoneView.topAnchor),
            completeTaskButton.leadingAnchor.constraint(equalTo: markAsDoneView.leadingAnchor, constant: 10),
    
            taskNameLabel.leadingAnchor.constraint(equalTo: markAsDoneView.trailingAnchor, constant: 8),
            taskNameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            
            timerStackView.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 4),
            timerStackView.leadingAnchor.constraint(equalTo: markAsDoneView.trailingAnchor),
            
            nextSubTaskStackView.leadingAnchor.constraint(equalTo: markAsDoneView.trailingAnchor),
            nextSubTaskStackView.topAnchor.constraint(equalTo: timerStackView.bottomAnchor),
            
            completedSubtasksLabel.topAnchor.constraint(equalTo: nextSubTaskStackView.bottomAnchor),
            completedSubtasksLabel.leadingAnchor.constraint(equalTo: markAsDoneView.trailingAnchor),
            
            completionPercentageLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            completionPercentageLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            taskProgressView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -5),
            taskProgressView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            taskProgressView.trailingAnchor.constraint(equalTo: completionPercentageLabel.leadingAnchor, constant: -5),
            
            delayStatusIndicatorView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            delayStatusIndicatorView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            delayStatusIndicatorView.widthAnchor.constraint(equalToConstant: 20),
            delayStatusIndicatorView.heightAnchor.constraint(equalToConstant: 20),
            
            
            warningIconImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            warningIconImageView.trailingAnchor.constraint(equalTo: delayStatusIndicatorView.leadingAnchor, constant: -5),
            
            aiSuggestionImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            aiSuggestionImageView.widthAnchor.constraint(equalToConstant: 25),
            aiSuggestionImageView.heightAnchor.constraint(equalToConstant: 25),
            aiSuggestionImageView.trailingAnchor.constraint(equalTo: warningIconImageView.leadingAnchor, constant: -5),
            
        ])
    }
}

