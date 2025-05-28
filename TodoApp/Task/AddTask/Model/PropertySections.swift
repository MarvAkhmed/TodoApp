//
//  TaskDetailSections.swift
//  TodoApp
//
//  Created by Marwa Awad on 13.04.2025.
//


enum PropertySections: CaseIterable {
    case deadline, priority, subtask
    
    var title: String {
        switch self {
        case .deadline: return "Deadline"
        case .priority: return "Select Priority"
        case .subtask: return "Subtasks"
        }
    }
}


