//
//  Task.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 25/3/24.
//

import Foundation

struct Task: Hashable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
