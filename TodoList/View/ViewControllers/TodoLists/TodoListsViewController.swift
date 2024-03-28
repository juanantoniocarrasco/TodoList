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
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        loadData()
        setupUI()
    }
    
    private func loadData() {
        do {
            todoLists = try context.fetch(TodoList.fetchRequest())
        } catch {
            print("error al load data")
        }
    }
    
    private func saveData() {
        do {
            try context.save()
            updateDatasource()
        } catch {
            print("error al save data")
        }
    }
}

private extension TodoListsViewController {
    
    func setupUI() {
        setupConstraints()
        configureNavigationBarTitle()
        configureAddButton()
        configureDatasource()
        updateDatasource()
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
    
    @objc func addButtonAction() {
        let newTodoList = TodoList(context: context)
        newTodoList.name = "New TodoList"
        todoLists.append(newTodoList)
        saveData()
    }
    
    func configureDatasource() {
        dataSource = .init(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, todoList in
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.todoListCell,
                                                     for: indexPath)
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

}

// MARK: - UITableViewDelegate
extension TodoListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let self else { return }
            context.delete(todoLists[indexPath.row])
            todoLists.remove(at: indexPath.row)
            saveData()
            updateDatasource()
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return .init(actions: [deleteAction])
    }
}
