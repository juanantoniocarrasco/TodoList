//
//  ViewController.swift
//  TodoList
//
//  Created by Juan Antonio Carrasco del Cid on 24/3/24.
//

import UIKit

final class TodoListViewController: UIViewController {
    
    // MARK: - Section
    enum Section: Int, CaseIterable {
        case todo
        case completed
    }
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        let cellId = Constants.ViewIds.taskCell.rawValue
        let headerId = Constants.ViewIds.todoListHeader.rawValue
        tableView.register(TaskTableViewCell.self,
                           forCellReuseIdentifier: cellId)
        tableView.register(UITableViewHeaderFooterView.self,
                           forHeaderFooterViewReuseIdentifier: headerId)
        return tableView
    }()
    
    // MARK: - Properties
    private var tasks: [Task]
    private var dataSource: UITableViewDiffableDataSource<Section, Task>?
    
    // MARK: - Initialization
    init() {
        self.tasks = [Task(title: "Task 1", isCompleted: false),
                      Task(title: "Task 2", isCompleted: true),
                      Task(title: "Task 3", isCompleted: false)]
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

// MARK: - Private functions
private extension TodoListViewController {
    
    func setupUI() {
        setupConstraints()
        configureNavigationBarTitle()
        configureDatasource()
        updateDatasource()
    }
    
    func setupConstraints() {
        view.fill(with: tableView)
    }
    
    func configureNavigationBarTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let title = Constants.Literals.todoListTitle.rawValue
        self.title = title.capitalized
    }
    
    func configureDatasource() {
        dataSource = .init(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, task in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewIds.taskCell.rawValue,
                                                           for: indexPath) as? TaskTableViewCell
            else { return .init() }
            
            cell.configure(with: task, 
                           taskCompletedAction: self?.handleTaskCompletion(for: task))
            return cell
        })
        tableView.dataSource = dataSource
    }
    
    func handleTaskCompletion(for task: Task) -> () -> Void {
        return { [weak self] in
            guard let index = self?.tasks.firstIndex(of: task) else { return }
            self?.tasks[index].isCompleted.toggle()
            self?.updateDatasource()
        }
    }
    
    func updateDatasource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
        snapshot.appendSections(Section.allCases)
        let todoTasks = tasks.filter { !$0.isCompleted }
        let completedTask = tasks.filter { $0.isCompleted }
        snapshot.appendItems(todoTasks, 
                             toSection: .todo)
        snapshot.appendItems(completedTask,
                             toSection: .completed)
        dataSource?.defaultRowAnimation = .left
        dataSource?.apply(snapshot,
                          animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension TodoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let id = Constants.ViewIds.todoListHeader.rawValue
        guard
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: id),
            let section = Section(rawValue: section)
        else { 
            return nil
        }
        return view(for: header, in: section)
    }
    
    private func view(for header: UITableViewHeaderFooterView, in section: Section) -> UIView? {
        switch section {
            case .todo:
                let text = Constants.Literals.todo.rawValue
                header.textLabel?.text = text.uppercased()
                
            case .completed:
                let text = Constants.Literals.completed.rawValue
                header.textLabel?.text = text.uppercased()
        }
        header.contentView.backgroundColor = .white
        return header
    }
}
