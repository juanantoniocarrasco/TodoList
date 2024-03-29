//
//  ViewController.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 24/3/24.
//

import UIKit

final class TodoListDetailViewController: UIViewController {
    
    // MARK: - Section
    enum Section: Int, CaseIterable {
        case todo
        case completed
    }
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(
            TaskTableViewCell.self,
            forCellReuseIdentifier: Identifier.taskCell
        )
        tableView.register(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: Identifier.todoListHeader
        )
        return tableView
    }()
    
    // MARK: - Properties
    private var todoList: TodoList
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Task> = makeDataSource()
    private weak var errorPresenter: ErrorPresenter?

    
    // MARK: - Initialization
    init(todoList: TodoList) {
        self.todoList = todoList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: - Persistence handling
private extension TodoListDetailViewController {
    
    func loadData() {
        let request = TodoList.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", todoList.id!.uuidString) // TODO: Forceunwrap
        request.predicate = predicate
        do {
            let results = try PersistenceController.shared.fetch(request)
            guard let fetchedTodoList = results.first else { return }
            todoList = fetchedTodoList
            updateDatasource()
        } catch {
            print("error al load data")
        }
    }
    
    func createTask(withTitle title: String) {
        do {
            try PersistenceController.shared.createTask(withTitle: title, in: todoList)
            loadData()
        } catch {
            print("error al add object")
        }
    }
    
    func delete(_ task: Task) {
        do {
            try PersistenceController.shared.delete(object: task)
            loadData()
        } catch {
            print("error al borrar task")
        }
    }
    
    func handleTaskCompletion(for task: Task) {
        task.isCompleted.toggle()
        do {
            try PersistenceController.shared.save()
            var snapshot = dataSource.snapshot()
            snapshot.reloadItems([task])
            dataSource.apply(snapshot, animatingDifferences: false)
            loadData()
        } catch {
            
        }
    }
}

// MARK: - Helpers
private extension TodoListDetailViewController {
    
    func showNewTaskAlertController() {
        let alertController = UIAlertController(
            title: "task",
            message: nil,
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.placeholder = "task"
        }
        let cancelAction = UIAlertAction(title: Literal.cancel, style: .cancel)
        let saveAction = UIAlertAction(title: Literal.save, style: .default) { [weak self] _ in
            guard
                let textField = alertController.textFields?.first,
                let taskTitle = textField.text,
                !taskTitle.isEmpty
            else {
                return
            }
            self?.createTask(withTitle: taskTitle)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true)
    }
    
    func sortByCreationDate(_ tasks: [Task]) -> [Task] {
        tasks.sorted {
            guard let date1 = $0.creationDate,
                  let date2 = $1.creationDate else { return false }
            return date1 < date2
        }
    }
}

// MARK: - SetupUI
private extension TodoListDetailViewController {
    
    func setupUI() {
        setupConstraints()
        configureNavigationBarTitle()
        configureAddButton()
        tableView.dataSource = dataSource
        updateDatasource()
    }
    
    func setupConstraints() {
        view.fill(with: tableView)
    }
    
    func configureNavigationBarTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = todoList.name
    }
    
    func configureAddButton() {
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonAction)
        )
    }
    
    @objc func addButtonAction() {
        // navigate to create new task
        showNewTaskAlertController()
    }
}

// MARK: - UITableViewDiffableDatasource
private extension TodoListDetailViewController {
    
    func makeDataSource() -> UITableViewDiffableDataSource<Section, Task> {
        .init(tableView: tableView,
              cellProvider: {  tableView, indexPath, task in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Identifier.taskCell,
                for: indexPath
            ) as? TaskTableViewCell
            cell?.configure(with: task, delegate: self)
            return cell
        })
    }
    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshot.appendSections(Section.allCases)
        let sortedTasks = sortByCreationDate(todoList.tasks)
        let todoTasks = sortedTasks.filter { !$0.isCompleted }
        let completedTasks = sortedTasks.filter { $0.isCompleted }
        snapshot.appendItems(todoTasks,
                             toSection: .todo)
        snapshot.appendItems(completedTasks,
                             toSection: .completed)
        dataSource.defaultRowAnimation = .left
        dataSource.apply(snapshot)
    }
}
    
// MARK: - UITableViewDelegate
extension TodoListDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let taskToDelete = self?.dataSource.itemIdentifier(for: indexPath) else { return }
            self?.delete(taskToDelete)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Identifier.todoListHeader),
              let section = Section(rawValue: section) else { return nil }
        return view(for: header, in: section)
    }
    
    private func view(for header: UITableViewHeaderFooterView, in section: Section) -> UIView? {
        switch section {
            case .todo:
                header.textLabel?.text = Literal.todo.uppercased()
            case .completed:
                header.textLabel?.text = Literal.completed.uppercased()
        }
        return header
    }
}

// MARK: - TaskTableViewCellViewDelegate
extension TodoListDetailViewController: TaskTableViewCellViewDelegate {
    func checkButtonTapped(for task: Task) {
        handleTaskCompletion(for: task)
    }
}
