//
//  AddSubtaskViewModel.swift
//  TodoApp
//
//  Created by Marwa Awad on 27.03.2025.
//

import Foundation
import Combine
import SentencepieceTokenizer

class AddSubtaskViewModel {
    
    // MARK: - Singleton
    public static let shared = AddSubtaskViewModel()
    
    private init(){}
    
    // MARK: - Properties
    @Published var subtasks: [SubtaskModel] = []
    private var switchStates: [UUID: Bool]  = [:]
    private var deadlines: [UUID: Date] = [:]
    private var cachedHeights: [UUID: CGFloat] = [:]
    private var timers: [UUID: Timer] = [:]
    private var callbacks: [UUID: (String) -> Void] = [:]
 
    // MARK: - Subtasks Logic
    func addSubtask(subtask: SubtaskModel){
        subtasks.append(subtask)
    }
    
    func getSubtasksCount() -> Int {
        return subtasks.count
    }
    
    func getSubtasks() -> [SubtaskModel] {
        return subtasks
    }
    
    func clearSubtasks() {
        subtasks.removeAll()
    }
    
    func getId(of subtsk: SubtaskModel) -> UUID {
        return subtsk.id
    }
    
    func getId(at index: Int) -> UUID {
        return subtasks[index].id
    }

    // MARK: - SwitchState Handling
    func setSwitchStatus(of id: UUID, to status: Bool) {
        switchStates[id] = status
    }
    
    func getSwitchStatus(of id: UUID) -> Bool {
        return switchStates[id] ?? false
    }
    
    func handleSwitchChange(for id: UUID, isOn: Bool) {
        setSwitchStatus(of: id, to: isOn)
        
        if !isOn,
           let defaultDeadline = AddTasksViewModel.shared.getCombinedDateAndTime() {
            setDeadline(for: id, date: defaultDeadline)
        }
    }
    
    
    func cacheHeight(for id: UUID, height: CGFloat) {
        cachedHeights[id] = height
    }
    
    func getCachedHeight(for id: UUID) -> CGFloat {
        return cachedHeights[id] ?? 44
    }
    
    // MARK: - Deadline Handling
    let defaultDeadline =  AddTasksViewModel.shared.getCombinedDateAndTime()
    
    func setDeadline(for id: UUID, date: Date) {
        deadlines[id] = date
    }
    
    func getDeadline(for id: UUID) -> Date? {
        return deadlines[id] ?? defaultDeadline
    }
    
    func formattedTimeLeft(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "d MMMM yyyy 'в' HH:mm"
        return formatter.string(from: date)
    }
    
    func updateSubtaskDeadlineIfSwitchOff(_ subtaskID: UUID) {
        if !getSwitchStatus(of: subtaskID) {
            let defaultDeadline = handleDefaultDatePicked(for: subtaskID)
            setDeadline(for: subtaskID, date: defaultDeadline)
        }
    }
    
    func handleDefaultDatePicked(for id: UUID) -> Date{
        guard !getSwitchStatus(of: id),
              let defaultDeadline = AddTasksViewModel.shared.getCombinedDateAndTime() else { return .now}
        setDeadline(for: id, date: defaultDeadline)
        return defaultDeadline
    }
    
    func handleManualDatePicked(for id: UUID, newDate: Date) {
        setDeadline(for: id, date: newDate)
    }
    
    //MARK: - SaveSubtask TextView
    func updateSubtaskText(at indexRow: Int, with text: String) {
        guard indexRow < subtasks.count else { return }
        subtasks[indexRow].title = text
    }
    
    func getSubtaskText(at indexRow: Int) -> String {
        guard indexRow < subtasks.count else { return "" }
        return subtasks[indexRow].title
    }
               
}

