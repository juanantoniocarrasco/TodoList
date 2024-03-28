////
////  ViewController.swift
////  TodoList
////
////  Created by Juan Antonio Carrasco del Cid on 24/3/24.
////
//
//import UIKit
//
//final class TodoListDetailViewController: UIViewController {
//    
//    // MARK: - Section
//    enum Section: Int, CaseIterable {
//        case todo
//        case completed
//    }
//    
//    // MARK: - Views
//    private lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        let cellId = Constants.ViewIds.taskCell.rawValue
//        let headerId = Constants.ViewIds.todoListHeader.rawValue
//        tableView.register(TaskTableViewCell.self,
//                           forCellReuseIdentifier: cellId)
//        tableView.register(UITableViewHeaderFooterView.self,
//                           forHeaderFooterViewReuseIdentifier: headerId)
//        return tableView
//    }()
//    
//    // MARK: - Properties
//    weak var errorPresenter: ErrorPresenter?
//    private var tasks: [Task]
//    private var dataSource: UITableViewDiffableDataSource<Section, Task>?
//    
//    // MARK: - Initialization
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Life cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//}
//
//// MARK: - Private functions
//private extension TodoListDetailViewController {
//    
//    func setupUI() {
//        setupConstraints()
//        configureNavigationBarTitle()
//        configureAddButton()
//        configureDatasource()
//        updateDatasource()
//    }
//    
//    func setupConstraints() {
//        view.fill(with: tableView)
//    }
//    
//    func configureNavigationBarTitle() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//        let title = Constants.Literals.todoListTitle.rawValue
//        self.title = title.capitalized
//    }
//    
//    func configureAddButton() {
//        navigationItem.rightBarButtonItem = .init(
//            barButtonSystemItem: .add,
//            target: self,
//            action: #selector(addButtonAction)
//        )
//    }
//    
//    @objc func addButtonAction() {
//        // navigate to create new task
//    }
//    
//    func configureDatasource() {
//        dataSource = .init(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, task in
//            guard
//                let self,
//                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ViewIds.taskCell.rawValue,
//                                                         for: indexPath) as? TaskTableViewCell
//            else { 
//                return .init()
//            }
//            cell.configure(with: task, delegate: self)
//            return cell
//        })
//        dataSource?.defaultRowAnimation = .left
//        tableView.dataSource = dataSource
//    }
//    
//    func updateDatasource(animating: Bool = true) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Task>()
//        snapshot.appendSections(Section.allCases)
//        let todoTasks = tasks.filter { !$0.isCompleted }
//        let completedTask = tasks.filter { $0.isCompleted }
//        snapshot.appendItems(todoTasks, 
//                             toSection: .todo)
//        snapshot.appendItems(completedTask,
//                             toSection: .completed)
//        dataSource?.apply(snapshot,
//                          animatingDifferences: animating)
//    }
//    
//    func handleTaskCompletion(for task: Task) {
//        guard let index = tasks.firstIndex(of: task) else {
//            errorPresenter?.presentError()
//            return
//        }
//        tasks[index].isCompleted.toggle()
//        updateDatasource()
//    }
//    
//    func handleEdition(ofTitle title: String, for task: Task) {
//        guard let index = tasks.firstIndex(of: task) else {
//            errorPresenter?.presentError()
//            return
//        }
//        tasks[index].title = title
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension TodoListDetailViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
//            guard let taskToDelete = self?.dataSource?.itemIdentifier(for: indexPath) else {
//                return
//            }
//            self?.tasks.removeAll { $0.id == taskToDelete.id }
//            self?.updateDatasource()
//        }
//        deleteAction.image = UIImage(systemName: "trash.fill")
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        configuration.performsFirstActionWithFullSwipe = true
//        return configuration
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let id = Constants.ViewIds.todoListHeader.rawValue
//        guard
//            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: id),
//            let section = Section(rawValue: section)
//        else { 
//            return nil
//        }
//        return view(for: header, in: section)
//    }
//    
//    private func view(for header: UITableViewHeaderFooterView, in section: Section) -> UIView? {
//        switch section {
//            case .todo:
//                let text = Constants.Literals.todo.rawValue
//                header.textLabel?.text = text.uppercased()
//            case .completed:
//                let text = Constants.Literals.completed.rawValue
//                header.textLabel?.text = text.uppercased()
//        }
//        return header
//    }
//}
//
//extension TodoListDetailViewController: TaskTableViewCellViewDelegate {
//    
//    func textFieldDidChange(for task: Task, text: String) {
//        handleEdition(ofTitle: text, for: task)
//    }
//    
//    func checkButtonTapped(for task: Task) {
//        handleTaskCompletion(for: task)
//    }
//    
//    func textFieldDidEndEditing() {
//        updateDatasource(animating: false)
//    }
//}
