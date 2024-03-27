//
//  UIView+Extension.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 27/3/24.
//

import UIKit

extension UIView {
    
    func fill(with view: UIView, edges: UIEdgeInsets = .zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: edges.top),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edges.left),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -edges.right),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -edges.bottom)
        ])
    }
}
