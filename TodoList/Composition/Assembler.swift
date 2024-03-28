//
//  Assembler.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 28/3/24.
//

import UIKit

enum Assembler {
    
    static func makeNavigationController() -> UINavigationController {
        let viewController = TodoListsViewController()
        let errorPresenter = AlertErrorPresenter(viewController: viewController)
//        viewController.errorPresenter = errorPresenter
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
