//
//  TaskViewController.swift
//  DataBaseChallenge
//
//  Created by Eduardo Vital Alencar Cunha on 20/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import UIKit

class TaskViewController: UITableViewController {
    // MARK: - Properties
    var delegate: TaskViewControllerDelegate?
    var task: Task?
    var isNewTask = true

    // MARK: - IBOutlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var limitDatePicker: UIDatePicker!

    // MARK: - IBActions
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        if  let name = self.nameTextField.text,
            let description = self.descriptionTextView.text,
            !name.isEmpty {

            let limitDate = self.limitDatePicker.date

            let task = Task(name: name, description: description, limitDate: limitDate, id: (self.task?.id))

            if self.isNewTask {
                if (self.delegate?.save(task: task))! {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Failed to save task")
                }
            } else {
                if (self.delegate?.update(task: task))! {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Failed to save task")
                }
            }
        } else {
            let alert = UIAlertController(title: "Campos não preenchidos", message: "O campo NOME deve ser preenchidos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func popViewController(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.gray.cgColor

        if let task = self.task {
            self.isNewTask = false

            self.nameTextField.text = task.name
            self.descriptionTextView.text = task.textDescription
            self.limitDatePicker.date = task.limitDate
        }
    }

}

protocol TaskViewControllerDelegate {
    func save(task: Task) -> Bool
    func update(task: Task) -> Bool
}
