//
//  PersistenceController.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 28/3/24.
//

import CoreData

struct PersistenceController {
    
    static let shared = Self.init()
    
    let persistentContainer = NSPersistentContainer(name: "Model")
    
    private init() {
    
    }
}
