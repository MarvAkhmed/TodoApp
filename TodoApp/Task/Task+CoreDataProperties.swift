//
//  Task+CoreDataProperties.swift
//  TodoApp
//
//  Created by Marwa Awad on 24.05.2025.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskTitle: String?
    @NSManaged public var deadline: Date?
    @NSManaged public var aiSuggestion: String?
    @NSManaged public var taskType: TaskType?
    @NSManaged public var subtasks: NSSet?
    @NSManaged public var aiSuggestedSubs: NSSet?
    @NSManaged public var customPriority: Priority?

}

// MARK: Generated accessors for subtasks
extension Task {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: Subtask)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: Subtask)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}

// MARK: Generated accessors for aiSuggestedSubs
extension Task {

    @objc(addAiSuggestedSubsObject:)
    @NSManaged public func addToAiSuggestedSubs(_ value: Subtask)

    @objc(removeAiSuggestedSubsObject:)
    @NSManaged public func removeFromAiSuggestedSubs(_ value: Subtask)

    @objc(addAiSuggestedSubs:)
    @NSManaged public func addToAiSuggestedSubs(_ values: NSSet)

    @objc(removeAiSuggestedSubs:)
    @NSManaged public func removeFromAiSuggestedSubs(_ values: NSSet)

}

extension Task : Identifiable {

}
