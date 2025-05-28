//
//  TasksViewController.swift
//  TodoApp
//
//  Created by Marwa Awad on 10.03.2025.
//

import UIKit

class TasksViewController: UIViewController{

    //MARK: - Properties
    let tasksViewModel = AddTasksViewModel.shared
    

    //MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(TaskCellViewCell.self, forCellReuseIdentifier: TaskCellViewCell.identifier)
        return table
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.setupNavigationBar()
        self.setupUI()
    }
    
    //MARK: - NavigaionBar
    private func setupNavigationBar() {
        navigationItem.title  = "tasks"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItem = addButton
    }
    
    //MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor  = .clear
        view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    //MARK: - Actions
    @objc private func addAction() {
        let addTaskViewController = AddTaskViewController()
        let newNavigationController = UINavigationController(rootViewController: addTaskViewController)
        newNavigationController.modalPresentationStyle = .popover
        addTaskViewController.addingTaskDelegate = self
        self.present(newNavigationController, animated: true)
    }
}

//MARK: -  TableView DateSource and Delegate extension
extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksViewModel.getTasks().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCellViewCell.identifier, for: indexPath) as? TaskCellViewCell else { return UITableViewCell()}
        let task = tasksViewModel.getTasks()[indexPath.row]
        cell.configure(with: task)
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        111
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsViewController = TaskDetailsController()
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}


extension TasksViewController: AddTaskViewControllerDelegate {
    func didAddTask() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
       
    }
}
