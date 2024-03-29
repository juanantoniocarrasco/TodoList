//
//  TodoList+CoreDataClass.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 29/3/24.
//
//

import Foundation
import CoreData

@objc(TodoList)
public class TodoList: NSManagedObject {
    
    var tasks: [Task] {
        get {
            guard let tasksSet = tasksSet as? Set<Task> else { return [] }
            return Array(tasksSet)
        }
        set(newTasksArray) {
            let existingTasks = mutableSetValue(forKey: "tasksSet")
            existingTasks.removeAllObjects()
            
            newTasksArray.forEach {
                existingTasks.add($0)
            }
        }
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
    }
    
    func append(_ task: Task) {
        let existingTasks = mutableSetValue(forKey: "tasksSet")
        existingTasks.add(task)
    }
}
