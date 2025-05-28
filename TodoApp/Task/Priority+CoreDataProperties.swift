//
//  Priority+CoreDataProperties.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.05.2025.
//
//

import Foundation
import CoreData


extension Priority {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Priority> {
        return NSFetchRequest<Priority>(entityName: "Priority")
    }

    @NSManaged public var priorityLevel: String?
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension Priority {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}

extension Priority : Identifiable {

}
