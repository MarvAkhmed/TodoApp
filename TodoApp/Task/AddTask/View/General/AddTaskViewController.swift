//
//  TaskAddViewController.swift
//  TodoApp
//
//  Created by Marwa Awad on 15.03.2025.
//

import UIKit
import Combine

protocol AddTaskViewControllerDelegate: AnyObject {
    func didAddTask()
}

enum ValidationError: Error {
    case missingFields
    case missingPriority
    
}

class AddTaskViewController: UIViewController {
    
    // MARK: - Singleton
    private let viewModel = AddTasksViewModel.shared
    let subtasksViewModel = AddSubtaskViewModel.shared
    static let shared = AddTaskViewController()
    // MARK: -  Properties
    private var isExpandedTypesTable = false
    private lazy var uiManager = AddTaskUIManager(viewController: self)
    private var taskSectionDatasource: UITableViewDiffableDataSource<String, TaskTypeL>!
    private var cancellables = Set<AnyCancellable>()
    private var propertySettingsDataSource: UITableViewDiffableDataSource<PropertySections, PropertyItem>!
    private var lastSelectedIndexPath: IndexPath?
    weak var addingTaskDelegate: AddTaskViewControllerDelegate?
    
    //MARK: - UI Componenets
    /// task title
    lazy var taskTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    /// task type
    lazy var taskSectionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Category"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        return textField
    }()
    
    lazy var taskSectionExpandButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(togglePickerView), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return button
    }()
    
    lazy var taskSectionHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [taskSectionTextField, taskSectionExpandButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var taskSectionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "typeCell")
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 18
        return tableView
    }() 
    
    
    lazy var upperContentViewWithoutTable: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var upperContentViewWithTable: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    /// Property Table
    lazy var propertyTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.allowsSelection = false
        
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.register(DeadlineSectionCell.self, forCellReuseIdentifier: DeadlineSectionCell.identifier)
        tableView.register(PrioritySectionTableView.self, forCellReuseIdentifier: PrioritySectionTableView.reuseIdentifier)
        tableView.register(SubtasksSectionViewCell.self, forCellReuseIdentifier: SubtasksSectionViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Actions Of the NavigationBar
     private func getCurrentTask() throws -> TaskModel {
        guard let deadline = viewModel.getCombinedDateAndTime(),
              let taskTitle = taskTitleTextField.text, !taskTitle.isEmpty,
              let taskTypeTitle = taskSectionTextField.text, !taskTypeTitle.isEmpty
        else {
            emptyFieldAlert()
            throw ValidationError.missingFields
        }

        let taskId = viewModel.currentTaskId
        let currentSubtasks = subtasksViewModel.getSubtasks()
        viewModel.setSubtasks(from: currentSubtasks, to: taskId)
        let subtasks = viewModel.getSubtasks(ofTaskWithId: taskId)
        let title = taskTitle
        let type = TaskTypeL(title: taskTypeTitle)
        
        guard let selectedPriority = try? viewModel.getSelectedPriority(for: taskId) else {
            throw ValidationError.missingPriority
        }
        
        let newTask = viewModel.addNewTask(id: taskId, title: title, type: type, subtasks: subtasks, deadline: deadline, selectedPriority: selectedPriority)
        
        return newTask
    }
    //MARK: - Actions
    @objc private func doneButtonTapped() {
        do {
            let currentTask = try getCurrentTask()
            dismiss(animated: true, completion: { [weak self] in
                self?.saveTask(currentTask)
                self?.resetFields()
            })
        } catch ValidationError.missingPriority {
            missingPriorityAlert()
            
        } catch ValidationError.missingFields {
            emptyFieldAlert()
        } catch {
            showUnexpectedErrorAlert(error)
        }
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: { [weak self] in
            self?.resetFields()
        })
    }

    
    // MARK: - Navigation Bar
    func loadNavigaionBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.title = "Add Task"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isModalInPresentation = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observeSelectedTaskType()
        loadNavigaionBar()
        uiManager.setupDefaultUI()
        setupTaskSectionDatasource()
        dequeuePropertiesTableCell()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Task Type Table Setup (First Table)
    private func toogleTableViewVisibility() {
        isExpandedTypesTable.toggle()
        updateArrowDirection()
        isExpandedTypesTable ? uiManager.setupExpandedTypeUI() : uiManager.setupDefaultUI()
    }
    
    private func updateArrowDirection() {
        let arrowDirection = isExpandedTypesTable ? "chevron.down" : "chevron.backward"
        uiManager.updateArrowDirection(taskSectionExpandButton, to: arrowDirection)
    }
    
    func setupTaskSectionDatasource() {
        taskSectionDatasource = UITableViewDiffableDataSource<String, TaskTypeL>(tableView: taskSectionsTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "typeCell", for: indexPath) as UITableViewCell
            let taskType = self.viewModel.taskTypes[indexPath.row]
            cell.textLabel?.text = taskType.title
            cell.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0.05))
            cell.selectionStyle = .none
            self.gestureDelegate(cell: cell)
            return cell
        })
        applyTaskTypeSnapshot()
    }
    
    func applyTaskTypeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, TaskTypeL>()
        snapshot.appendSections(["section1"])
        snapshot.appendItems(viewModel.taskTypes)
        taskSectionDatasource.apply(snapshot, animatingDifferences: true)
    }
    
    func gestureDelegate(cell: UITableViewCell) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCellTap(_:)))
        cell.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Selectors: Task Type Table Actions (First Table)
    @objc private func togglePickerView() {
        toogleTableViewVisibility()
    }
    
    @objc func handleCellTap(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? UITableViewCell,
              let indexPath = taskSectionsTableView.indexPath(for: cell) else { return }
        _ = viewModel.selectTaskType(at: indexPath.row)
        toogleTableViewVisibility()
    }
    
    private func observeSelectedTaskType() {
        viewModel.$selectedTaskType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] selectedType in
                self?.taskSectionTextField.text = selectedType?.title
            }.store(in: &cancellables)
    }
    
    // MARK: - Task Sections Table Setup (Second Table)
    private func dequeuePropertiesTableCell() {
        propertySettingsDataSource = UITableViewDiffableDataSource<PropertySections, PropertyItem>(tableView: propertyTableView) { tableView, indexPath, item in
            
            switch indexPath.section {
            case 0:
                guard let secondCell = tableView.dequeueReusableCell(withIdentifier: DeadlineSectionCell.identifier, for: indexPath) as? DeadlineSectionCell else { return UITableViewCell()}
                if indexPath.row == 0 {
                    secondCell.setupUI(picker: secondCell.datePicker)
                } else if indexPath.row == 1 {
                    secondCell.setupUI(picker: secondCell.timePicker)
                }
                secondCell.backgroundColor = .clear
                let title = item.text
                secondCell.textLabel?.text = title
                
                if let imageName = item.imageName {
                    secondCell.imageView?.image = self.setImageColor(imageName: imageName)
                } else {
                    secondCell.imageView?.image = nil
                }
                return secondCell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: PrioritySectionTableView.reuseIdentifier , for: indexPath) as? PrioritySectionTableView else { return UITableViewCell()}
                cell.backgroundColor = .clear
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SubtasksSectionViewCell.identifier, for: indexPath) as? SubtasksSectionViewCell else {
                    fatalError("can't Dequeue SubtaskSectionViewCell Identifier")
                }
                
                guard  let imageName = item.imageName  else { fatalError("icon not found")  }
                cell.imageView?.image = self.setImageColor(imageName: imageName)
                let title = item.text
                cell.textLabel?.text = title
                cell.titleTextTracer = self 
                cell.delegate = self
                return cell
            default:
                break
            }
            fatalError("Failed to dequeue a valid cell for section \(indexPath.section), row \(indexPath.row)")
            
        }
        applyPropertiesSnaphot()
    }
    
    private func setImageColor(imageName: String) -> UIImage? {
        guard let image = UIImage(systemName: imageName) else { return nil }
        
        switch imageName {
        case "calendar.circle.fill":
            return image.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        case "clock.fill":
            return image.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        default:
            return image.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        }
    }
    
    func applyPropertiesSnaphot() {
        var snapshot = NSDiffableDataSourceSnapshot<PropertySections, PropertyItem>()
        snapshot.appendSections([.deadline, .priority, .subtask])
        
        snapshot.appendItems([
            PropertyItem(imageName: "calendar.circle.fill", text: "Date:"),
            PropertyItem(imageName: "clock.fill", text: "Time:")
        ], toSection: .deadline)
        
        snapshot.appendItems([
            PropertyItem(imageName: nil, text: "")
        ], toSection: .priority)
        
        snapshot.appendItems([
            PropertyItem(imageName: "list.clipboard", text: "Subtasks")
        ], toSection: .subtask)
        
        propertySettingsDataSource.apply(snapshot, animatingDifferences: true)
    }
}

//MARK: - Needed delegate funcsions
extension AddTaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView? else { return UITableViewHeaderFooterView() }
        let sectionType = PropertySections.allCases[section]
        let title = sectionType.title
        header?.configure(with: title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 100
        default:
            return UITableView.automaticDimension
        }
    }
    


}

//MARK: - Save Logic
extension AddTaskViewController {
    private func saveTask(_ task: TaskModel) {
        viewModel.addTask(task: task)
        addingTaskDelegate?.didAddTask()
    }
    
    private func missingPriorityAlert() {
        let alert = UIAlertController(title: "Missing Priority", message: "Please select a priority for the task.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func emptyFieldAlert() {
        let alert = UIAlertController(title: "Missing Information",
                                      message: "Please don't leave any field empty",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "return to task", style: .default))
        present(alert, animated: true)
    }
    
    private func showUnexpectedErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Unexpected Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

//MARK: - Reset the Fields and Handling Dismiss Action
extension AddTaskViewController {
    private func resetFields() {
        viewModel.resetTaskId()
        subtasksViewModel.clearSubtasks()
    }
}

//MARK: - Conform to delegate
extension AddTaskViewController: TaskTitleTrace {
    func getCurrentTaskTitle() -> String {
        return taskTitleTextField.text ?? ""
    }
}

extension AddTaskViewController: SubtasksSectionViewCellDelegate {
    func didTapSubtasksCell() {
        let taskTitle = getCurrentTaskTitle()
        guard !taskTitle.isEmpty else {return}
        let nextVc = SubTaskViewController()
        nextVc.taskTitle = taskTitle
        navigationController?.pushViewController(nextVc, animated: true)
    }
}
