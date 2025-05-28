//
//  TaskCellModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 11.03.2025.
//

import UIKit

struct TaskModel: Identifiable {
    
    //MARK: - stored in the databsase properties
    let id:  UUID
    let taskTitle: String
    let taskType: TaskTypeL
    let subTasks: [SubtaskModel]?
    let completedSubtasks: [SubtaskModel]?
    let deadline: Date
    var AISuggestion: String?
    var AISuggestedSubtasks: [SubtaskModel]?
    var customPriority: PriorityItem?
    
    //MARK: - Computed Properties
    var numberOfSubtasks: Int {
        subTasks?.count ?? 0
    }
    
    var numberOfCompletedSubtasks: Int {
        self.completedSubtasks?.count ?? 0
    }
    
    var numberOfNotCompletedSubtasks: Int {
        return numberOfSubtasks - numberOfCompletedSubtasks
    }
    
    var isCompleted: Bool {
        if numberOfSubtasks > 0 && numberOfNotCompletedSubtasks == 0 {
            return true
        } else if numberOfNotCompletedSubtasks == 0  && numberOfSubtasks == 0{
            return false // i think this is useless
        }
        return false
    }
    
    var percentageCompletion: Int  {
        guard numberOfSubtasks > 0 else { return 0 }
        return (numberOfCompletedSubtasks * 100) / numberOfSubtasks
    }
    
    
    
    //MARK: - Initilizer
    init(id: UUID,
        taskTitle: String,
         taskType: TaskTypeL,
         subTasks: [SubtaskModel]?,
         deadline: Date,
         AISuggestedSubtasks: [SubtaskModel]? = nil,
         customPriority: PriorityItem ) {
        
        self.id = id
        self.taskTitle = taskTitle
        self.taskType = taskType
        self.subTasks = subTasks
        self.deadline = deadline
        self.AISuggestedSubtasks = AISuggestedSubtasks
        self.customPriority = customPriority
        self.completedSubtasks = []
        
        
    }
}
