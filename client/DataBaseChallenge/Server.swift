//
//  Server.swift
//  DataBaseChallenge
//
//  Created by Eduardo Vital Alencar Cunha on 08/07/17.
//  Copyright © 2017 BEPiD. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Server {
    static var delegate: ServerDelegate?

    static func get() {
        Alamofire.request("http://localhost:3000")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var tasks = [Task]()
                    for (_, subJson): (String, JSON) in json {
                        tasks.append(Task(json: subJson))
                    }
                    Server.delegate?.dealWith(tasks: tasks, on: .get)
                case .failure(let error):
                    Server.delegate?.failOnRequest(error: error, on: .get)
                }
        }
    }

    static func delete(id: String) {
        Alamofire.request("http://localhost:3000/\(id)", method: .delete)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let task = Task(json: JSON(value))
                    Server.delegate?.dealWith(task: task, on: .delete)
                case .failure(let error):
                    Server.delegate?.failOnRequest(error: error, on: .delete)
                }
        }
    }

    static func post(task: Task) {
        let params = task.toJSON()

        Alamofire.request("http://localhost:3000/",
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let task = Task(json: JSON(value))
                    Server.delegate?.dealWith(task: task, on: .post)
                case .failure(let error):
                    Server.delegate?.failOnRequest(error: error, on: .post)
                }
        }
    }

    static func patch(task: Task) {
        let params = task.toJSON()

        Alamofire.request("http://localhost:3000/\(task.id)",
                          method: .patch,
                          parameters: params,
                          encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let task = Task(json: JSON(value))
                    Server.delegate?.dealWith(task: task, on: .patch)
                case .failure(let error):
                    Server.delegate?.failOnRequest(error: error, on: .patch)
                }
        }
    }
}

protocol ServerDelegate {
    func dealWith(tasks: [Task], on method: HTTPMethod)
    func dealWith(task: Task, on method: HTTPMethod)
    func failOnRequest(error: Error, on method: HTTPMethod)
}
