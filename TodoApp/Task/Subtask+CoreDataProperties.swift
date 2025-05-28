//
//  Subtask+CoreDataProperties.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.05.2025.
//
//

import Foundation
import CoreData


extension Subtask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subtask> {
        return NSFetchRequest<Subtask>(entityName: "Subtask")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskId: UUID?
    @NSManaged public var title: String?
    @NSManaged public var order: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var deadline: Date?
    @NSManaged public var taskSuggestions: Task?
    @NSManaged public var taskSubtasks: Task?

}

extension Subtask : Identifiable {

}
