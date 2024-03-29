//
//  Task+CoreDataClass.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 29/3/24.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
        self.creationDate = Date()
    }
}
