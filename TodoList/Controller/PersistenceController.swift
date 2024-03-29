//
//  PersistenceController.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 28/3/24.
//

import CoreData

final class PersistenceController {
    
    static let shared = PersistenceController()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistentContainer")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // TODO: handle error
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {}
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] {
        try context.fetch(request)
    }
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
    
    func delete(_ object: NSManagedObject) throws {
        context.delete(object)
        try save()
    }
    
    func createTodoList(withName name: String) throws {
        let todoList = TodoList(context: context)
        todoList.name = name
        try save()
    }
    
    func createTask(withTitle title: String, in todoList: TodoList) throws {
        let task = Task(context: context)
        task.title = title
        task.todoList = todoList
        try save()
    }
}
