//
//  Task.swift
//  DataBaseChallenge
//
//  Created by Eduardo Vital Alencar Cunha on 20/06/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation
import SwiftyJSON

class Task {
    var id = "0"
    var name = ""
    var textDescription = ""
    var limitDate = Date()
    private var status = TaskStatus.RawValue()

    var statusEnum: TaskStatus {
        get {
            return TaskStatus(rawValue: self.status)!
        }
        set {
            self.status = newValue.rawValue
        }
    }

    convenience init(json: JSON) {
        self.init()

        self.id = json["_id"].stringValue
        self.name = json["title"].stringValue
        self.textDescription = json["description"].stringValue
        self.limitDate = json["dateLimit"].dateTime!
    }

    convenience init(name: String, description: String, limitDate: Date, id: String?) {
        self.init()

        if let existingId = id { self.id = existingId }

        self.name = name
        self.textDescription = description
        self.limitDate = limitDate
        self.statusEnum = .todo
    }

    func toJSON() -> [String: String] {
        return [
            "title": self.name as String,
            "description": self.textDescription as String,
            "dateLimit": Formatter.jsonDateTimeFormatter.string(from: self.limitDate) as String
        ]
    }
}

enum TaskStatus: String {
    case todo
    case doing
    case done
}

