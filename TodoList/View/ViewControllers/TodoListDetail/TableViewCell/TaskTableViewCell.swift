//
//  TaskTableViewCell.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 27/3/24.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    private let view = View()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with task: Task, delegate: TaskTableViewCellViewDelegate) {
        view.configure(with: task, delegate: delegate)
    }
    
    private func setupView() {
        contentView.fill(with: view)
        selectionStyle = .none
    }
}
