//
//  AddTasksViewModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 25.03.2025.
//

import Foundation
import Combine
import SentencepieceTokenizer

class AddTasksViewModel {
    
    //MARK: - Singletone
    public static let shared = AddTasksViewModel()
    
    private init() {
        setupTaskTypes()
    }
    
    //MARK: - Properties
    private var tasks: [TaskModel] = []
    var currentTaskSubtasks: [UUID: [SubtaskModel]] = [:]
    private(set) var currentTaskId: UUID = UUID()
    
    func resetTaskId() {
        currentTaskId = UUID()
    }
    
    //MARK: - General
    func addNewTask(id taskId: UUID, title: String, type: TaskTypeL, subtasks: [SubtaskModel], deadline: Date, selectedPriority: PriorityItem) -> TaskModel{
        return  TaskModel(id: taskId,
                          taskTitle: title,
                          taskType: type,
                          subTasks: subtasks,
                          deadline: deadline,
                          customPriority: selectedPriority)
    }
    
    func addTask(task: TaskModel)  {
        tasks.append(task)
    }
    
    func getTasks() -> [TaskModel] {
        return tasks
    }

    //MARK: - TaskType Selection Logic
    private(set) var taskTypes: [TaskTypeL] = []
    @Published var selectedTaskType: TaskTypeL?
    
    private func setupTaskTypes() {
        let titles = [
            "Work/Personal",
            "Personal Development",
            "Household/Chores",
            "Social & Relationships",
            "Finance & Budgeting",
            "Long term goals/projects",
            "Daily/Weekly/recurring tasks",
            "Other"
        ]
        taskTypes = titles.map { TaskTypeL(title: $0) }
    }
    
    func selectTaskType(at index: Int)  -> TaskTypeL {
        guard taskTypes.indices.contains(index) else {
            fatalError("Index out of bounds when selecting task type")
        }
        let selected = taskTypes[index]
        self.selectedTaskType = selected
        return selected
    }
    
    //MARK: - Deadline Section Logic
    private var selectedDate: Date?
    private var selectedTime: Date?
    
    private(set) var finalDeadline: Date?
    
    func setFinalDate(_ date: Date) {
        selectedDate = date
        updateCombinedDeadline()
    }
    
    func setFinalTime(_ time: Date) {
        selectedTime = time
        updateCombinedDeadline()
    }
    
    func updateCombinedDeadline() {
        guard let date = selectedDate,
              let time = selectedTime
        else {return}
        let calender = Calendar.current
        let timeComponents = calender.dateComponents([.hour, .minute, .second], from: time)
        if let combined = calender.date(bySettingHour: timeComponents.hour ?? 0,
                                        minute: timeComponents.minute ?? 0,
                                        second: timeComponents.second ?? 0,
                                        of: date) {
            
            finalDeadline = combined
        }
    }
    
    func getCombinedDateAndTime() -> Date? {
        updateCombinedDeadline()
        return finalDeadline
    }

    
    //MARK: - Priority Selection Section Logic
    private(set) var priorities: [PriorityItem] = PriorityItem.allCases
    private var selectedPriorityIndex: [UUID: Int] = [:]
    
    func getPrioreties() -> [PriorityItem] {
        return priorities
    }
    
    func toggleSelection(at index: Int, for taskId: UUID) {
        if selectedPriorityIndex[taskId] == index {
            selectedPriorityIndex[taskId] = nil
        } else {
            selectedPriorityIndex[taskId] = index
        }
    }
    
    /// check if this priority is already selected or no , i think we need this only in the proccess of entering the data
    func isSelected(at index: Int, for taskId: UUID) -> Bool {
        return selectedPriorityIndex[taskId] == index
    }
    
    /// get the selected priority, this will be used while saving data
    func getSelectedPriority(for taskId: UUID) throws -> PriorityItem {
        guard let index = selectedPriorityIndex[taskId],
              priorities.indices.contains(index) else {
            throw PriorityError.notFount
        }
        return priorities[index]
    }
    
    
    //MARK: - Add Subtasks Section Logic
    func setSubtasks(from subtasks: [SubtaskModel], to taskId: UUID) {
        currentTaskSubtasks[taskId] = subtasks
    }
    
    func getSubtasks(ofTaskWithId taskId: UUID) -> [SubtaskModel] {
        return currentTaskSubtasks[taskId] ?? []
    }
}

enum PriorityError: Error {
    case notFount
}
