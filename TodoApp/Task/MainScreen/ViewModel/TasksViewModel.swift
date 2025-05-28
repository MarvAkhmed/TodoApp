//
//  TasksViewModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 13.03.2025.
//

import Foundation

class TasksViewModel: ObservableObject {
    
    //MARK: - SingleTone
    static let shared = TasksViewModel()
    
    //MARK: - Initilizer
    private init() {}
    
    //MARK: - Variables
    private var tasks: [TaskModel] = []
    private var subTasks: [SubtaskModel] = []
    private  var startTime: Date?
    private var endTime: Date?
    
    //MARK: - Get Tasks
    func getTasks() -> [TaskModel] {
        return tasks
    }
    
    func getTasksCount() -> Int {
        return tasks.count
    }
}



