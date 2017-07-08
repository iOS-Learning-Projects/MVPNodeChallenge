//
//  ViewController.swift
//  DataBaseChallenge
//
//  Created by Eduardo Vital Alencar Cunha on 20/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    var tasks = [Task]()
    var filteredTasks = [Task]()
    var shouldShowSearchResults = false
    var searchController: UISearchController!

    // MARK: - IBOutlets
    @IBOutlet weak var tasksTableView: UITableView!

    // MARK: - IBActions


    // MARK: - Functions
    func filterTasksBy(name: String) {
        let lowerCaseSearch = name.lowercased()

        if name.isEmpty {
            self.filteredTasks = self.tasks
        } else {
            self.filteredTasks = self.tasks.filter() { t in
                return (t.name.lowercased().range(of: lowerCaseSearch) != nil)
            }
        }

    }

    func configureSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Busque a tarefa pelo nome aqui..."
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()

        // Place the search bar into tableview header
        self.tasksTableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - ViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Server.delegate = self
        Server.get()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTaskSegue" {
            let taskViewController = segue.destination as! TaskViewController
            taskViewController.delegate = self
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return self.filteredTasks.count
        } else {
            return self.tasks.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewTaskCell") as! PreviewTaskCell

        if shouldShowSearchResults {

            cell.nameLabel.text = self.filteredTasks[indexPath.row].name
        } else {
            cell.nameLabel.text = self.tasks[indexPath.row].name
        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Server.delegate = self
            Server.delete(id: self.tasks[indexPath.row].id)
        }
    }

}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: "taskViewController") as! TaskViewController

        taskViewController.task = self.tasks[indexPath.row]
        taskViewController.delegate = self

        self.navigationController?.pushViewController(taskViewController, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - TaskViewControllerDelegate
extension MainViewController: TaskViewControllerDelegate {

    func save(task: Task) -> Bool {
        Server.delegate = self
        Server.post(task: task)
        return true
    }

    func update(task: Task) -> Bool {
        Server.delegate = self
        Server.patch(task: task)
        return true
    }

}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        self.filterTasksBy(name: searchController.searchBar.text!)
        self.tasksTableView.reloadData()
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.shouldShowSearchResults = true
        self.tasksTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.shouldShowSearchResults = false
        self.tasksTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.tasksTableView.resignFirstResponder()
    }
}

extension MainViewController: ServerDelegate {
    func dealWith(tasks: [Task], on method: HTTPMethod) {
        self.tasks = tasks
        self.tasksTableView.reloadData()
    }

    func dealWith(task: Task, on method: HTTPMethod) {
        switch method {
        case .delete:
            self.tasks = self.tasks.filter() { (t) in
                return t.id != task.id
            }
        case .post:
            self.tasks.append(task)
        case .patch:
            self.tasks = self.tasks.map() { (t) in
                if t.id == task.id {
                    return task
                }
                return t
            }
        default:
            print("method \(method.rawValue) not implemented in dealWithTask")
        }
        self.tasksTableView.reloadData()
    }

    func failOnRequest(error: Error, on method: HTTPMethod){
        var message = ""

        switch method {
        case .get:
            message = "Erro ao recuperar tarefas do servidor."
        case .delete:
            message = "Erro ao deletar tarefa."
        case .post:
            message = "Erro ao criar tarefa."
        case .patch:
            message = "Erro ao atualizar tarefa."
        default:
            message = "Erro inesperado."
        }

        let alert = UIAlertController(title: "Erro", message: message + " Tente novamente", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "O K", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
