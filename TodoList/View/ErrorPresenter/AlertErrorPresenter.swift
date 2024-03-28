//
//  AlertErrorPresenter.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 27/3/24.
//

import UIKit

class AlertErrorPresenter: ErrorPresenter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func presentError() { // TODO: pasar a constantes
        let alertController = UIAlertController(title: "Error",
                                                message: "Se ha producido un error, intentalo de nuevo",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default))
        viewController.present(alertController, animated: true)
    }
}
