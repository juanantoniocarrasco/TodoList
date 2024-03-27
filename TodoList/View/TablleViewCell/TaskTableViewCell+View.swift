//
//  TaskTableViewCell+View.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 27/3/24.
//

import UIKit

extension TaskTableViewCell {
    
    final class View: UIView {
        
        // MARK: - Views
        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                checkButton,
                titleLabel
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
        
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            return label
        }()
        
        // MARK: - Properties
        private var checkButtonAction: (() -> Void)?
        
        // MARK: - Functions
        func configure(with task: Task, checkButtonAction: (() -> Void)?) {
            setupUI()
            titleLabel.text = task.title
            checkButton.isSelected = task.isCompleted
            self.checkButtonAction = checkButtonAction
        }
        
        private func setupUI() {
            fill(with: stackView, edges: .init(top: 8, left: 24, bottom: 8, right: 24))
        }
        
        @objc private func checkButtonTapped() {
            checkButtonAction?()
        }
    }
}
