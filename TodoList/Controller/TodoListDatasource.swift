////
////  TodoListDatasource.swift
////  TodoList
////
////  Created by Juan Antonio Carrasco del Cid on 28/3/24.
////
//
//import Foundation
//
//protocol TodoListDatasource {
//    func getAll() async throws -> [TodoList]
//    func get(by id: UUID) async throws -> TodoList
//    func save(_ todoList: TodoList) async throws
//    func delete(_ todoList: TodoList) async throws
//}
//
//final class TodoListDatasourceImp {
//    
//    var todoLists: [TodoList] = [
//        .init(title: "TodoList 1", tasks: tasks),
//        .init(title: "TodoList 2", tasks: tasks),
//        .init(title: "TodoList 3", tasks: tasks),
//        .init(title: "TodoList 4", tasks: tasks)
//    ]
//    
//    private static var tasks: [Task] = [
//        Task(title: "Task 1"),
//        Task(title: "Task 2", isCompleted: true),
//        Task(title: "Task 3")
//    ]
//}
