//
//  GetMyTodosResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/19/25.
//

import Foundation

struct GetMyTodosResponse: Decodable {
    let todos: [TodoEntityInGetMyTodos]
}

struct TodoEntityInGetMyTodos: Decodable {
    let id: Int
    let content: String
    var status: String
    var certificationContent: String?
    var certificationMediaUrl: String?
    var reviewFeedback: String?
}
