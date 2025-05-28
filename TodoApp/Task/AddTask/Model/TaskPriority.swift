//
//  Priority.swift
//  TodoApp
//
//  Created by Marwa Awad on 08.05.2025.
//

import UIKit

struct PriorityItem: Hashable, CaseIterable {
    
    let priority: PriorityLevel
    var title: String { priority.title }
    var color: UIColor { priority.color }
    
    init(priority: PriorityLevel) {
        self.priority = priority
        
    }
    
    static var allCases: [PriorityItem] = [
        PriorityItem(priority: .low),
        PriorityItem(priority: .medium),
        PriorityItem(priority: .high)
    ]
    
    enum PriorityLevel: String {
        case low
        case medium
        case high

        var title: String {
            switch self {
            case .low: return "Low"
            case .medium: return  "Medium"
            case .high: return "High"
            }
        }
        
        var color: UIColor {
            switch self {
            case .low: return UIColor.systemGreen
            case .medium: return UIColor.systemOrange
            case .high: return UIColor.systemRed
            }
        }
    }
    
}

