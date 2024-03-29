//
//  TaskTableViewCell+View.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 27/3/24.
//

import UIKit

protocol TaskTableViewCellViewDelegate: AnyObject {
    func checkButtonTapped(for task: Task)
}

extension TaskTableViewCell {
    
    final class View: UIView {
        
        // MARK: - Views
        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                checkButton,
                label,
                UIView()
            ])
            stackView.spacing = 12
            return stackView
        }()
        
        private lazy var checkButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "circle"), for: .normal)
            button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
            button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
            return button
        }()
    
        private let label: UILabel = {
            let label = UILabel()
            return label
        }()
        
        // MARK: - Initializer
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Properties
        weak var delegate: TaskTableViewCellViewDelegate?
        private var task: Task?
        
        // MARK: - Functions
        func configure(with task: Task, delegate: TaskTableViewCellViewDelegate?) {
            self.task = task
            self.delegate = delegate
            label.text = task.title
            checkButton.isSelected = task.isCompleted
        }
        
        private func setupUI() {
            fill(with: stackView, edges: .init(top: 8, left: 24, bottom: 8, right: 24))
        }
        
        @objc private func checkButtonTapped() {
            guard let task else { return }
            delegate?.checkButtonTapped(for: task)
        }
    }
}
