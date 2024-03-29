//
//  TodoListsViewController.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 28/3/24.
//

import UIKit

final class TodoListsViewController: UIViewController {
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(TodoListTableViewCell.self,
                           forCellReuseIdentifier: Identifier.todoListCell)
        return tableView
    }()
    
    private var todoLists: [TodoList] = []
    private var dataSource: UITableViewDiffableDataSource<Int, TodoList>?

    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
}

private extension TodoListsViewController {
    
    func setupUI() {
        setupConstraints()
        configureNavigationBarTitle()
        configureAddButton()
        configureDatasource()
    }
    
    func setupConstraints() {
        view.fill(with: tableView)
    }
    
    func configureNavigationBarTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Literal.todoLists.capitalized
    }
    
    func configureAddButton() {
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonAction)
        )
    }
    
    func configureDatasource() {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, todoList in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.todoListCell,
                                                           for: indexPath) as? TodoListTableViewCell
            else { return .init() }
            cell.configure()
            cell.textLabel?.text = todoList.name
            return cell
        })
        tableView.dataSource = dataSource
    }
    
    func updateDatasource(animating: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TodoList>()
        snapshot.appendSections([0])
        snapshot.appendItems(todoLists)
        dataSource?.apply(snapshot, animatingDifferences: animating)
    }
    
    func loadData() {
        do {
            let request = TodoList.fetchRequest()
            todoLists = try PersistenceController.shared.fetch(request)
            updateDatasource()
        } catch {
            print("error al load data")
        }
    }
    
    func createTodoList(withName name: String) {
        do {
            try PersistenceController.shared.createTodoList(withName: name)
            loadData()
        } catch {
            print("error al add object")
        }
    }
    
    func showNewTodoListAlertController() {
        let alertController = UIAlertController(
            title: Literal.newListTitle,
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.placeholder = Literal.newListPlaceholder
        }
        let cancelAction = UIAlertAction(title: Literal.cancel, style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: Literal.save, style: .default) { [weak self] _ in
            guard
                let textField = alertController.textFields?.first,
                let newListName = textField.text,
                !newListName.isEmpty 
            else {
                return
            }
            self?.createTodoList(withName: newListName)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func addButtonAction() {
        showNewTodoListAlertController()
    }

}

// MARK: - UITableViewDelegate
extension TodoListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = TodoListDetailViewController(todoList: todoLists[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let self else { return }
            do {
                try PersistenceController.shared.delete(todoLists[indexPath.row])
                loadData()
            } catch {
                print("error al delete object")
            }
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return .init(actions: [deleteAction])
    }
}
