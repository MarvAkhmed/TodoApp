//
//  TaskType+CoreDataProperties.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.05.2025.
//
//

import Foundation
import CoreData


extension TaskType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskType> {
        return NSFetchRequest<TaskType>(entityName: "TaskType")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var titile: String?
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension TaskType {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}

extension TaskType : Identifiable {

}
