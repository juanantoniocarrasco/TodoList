////
////  TaskTableViewCell+View.swift
////  TodoList
////
////  Created by Juan Antonio Carrasco del Cid on 27/3/24.
////
//
//import UIKit
//
//protocol TaskTableViewCellViewDelegate: AnyObject {
//    func textFieldDidChange(for task: TaskEntry, text: String)
//    func checkButtonTapped(for task: TaskEntry)
//    func textFieldDidEndEditing()
//}
//
//extension TaskTableViewCell {
//    
//    final class View: UIView {
//        
//        // MARK: - Views
//        private lazy var stackView: UIStackView = {
//            let stackView = UIStackView(arrangedSubviews: [
//                checkButton,
//                texfield,
//                UIView()
//            ])
//            stackView.spacing = 12
//            return stackView
//        }()
//        
//        private lazy var checkButton: UIButton = {
//            let button = UIButton(type: .custom)
//            button.setImage(UIImage(systemName: "circle"), for: .normal)
//            button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
//            button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
//            return button
//        }()
//        
//        private lazy var texfield: UITextField = {
//            let textfield = UITextField()
//            textfield.delegate = self
//            return textfield
//        }()
//        
//        // MARK: - Properties
//        weak var delegate: TaskTableViewCellViewDelegate?
//        private var task: TaskEntry?
//        
//        // MARK: - Functions
//        func configure(with task: TaskEntry, delegate: TaskTableViewCellViewDelegate?) {
//            self.task = task
//            self.delegate = delegate
//            setupUI()
//        }
//        
//        private func setupUI() {
//            fill(with: stackView, edges: .init(top: 8, left: 24, bottom: 8, right: 24))
//            guard let task else { return }
//            texfield.text = task.title
//            checkButton.isSelected = task.isCompleted
//        }
//        
//        @objc private func checkButtonTapped() {
//            guard let task else { return }
//            delegate?.checkButtonTapped(for: task)
//        }
//    }
//}
//
//// MARK: - UITextFieldDelegate
//extension TaskTableViewCell.View: UITextFieldDelegate {
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard
//            let task,
//            let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//        else {
//            return false
//        }
//        delegate?.textFieldDidChange(for: task, text: text)
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        delegate?.textFieldDidEndEditing()
//    }
//}
