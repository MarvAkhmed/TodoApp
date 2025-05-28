//
//  PropertyItem.swift
//  TodoApp
//
//  Created by Marwa Awad on 16.04.2025.
//

import Foundation

struct PropertyItem: Hashable {
    let id = UUID()
    let imageName: String?
    let text: String
}
