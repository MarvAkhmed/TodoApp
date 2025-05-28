//
//  SubtaskModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 28.03.2025.
//

import UIKit

struct SubtaskModel: Hashable, Identifiable {
    let id = UUID()
    let taskId: UUID
    var title: String
    var order: Int
    var isCompleted: Bool
    var timeLeft: Date

    func hash(into hasher: inout Hasher) {
       hasher.combine(id)
    }
    
    init(taskId: UUID, title: String, order: Int, isCompleted: Bool = false, timeLeft: Date) {
        self.taskId = taskId
        self.title = title
        self.order = order
        self.isCompleted = isCompleted
        self.timeLeft = timeLeft
    }
}

