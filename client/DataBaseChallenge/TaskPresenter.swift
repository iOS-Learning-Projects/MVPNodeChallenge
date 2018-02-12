//
//  TaskPresenter.swift
//  DataBaseChallenge
//
//  Created by Eduardo Vital Alencar Cunha on 09/07/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation

class TaskPresenter {
    var tasks = [Task]()
    var filteredTasks = [Task]()

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

}
