//
//  TodosDataSource.swift
//  dogether
//
//  Created by seungyooooong on 3/8/25.
//

import Foundation

final class TodosDataSource {
    static let shared = TodosDataSource()
    
    private init() { }
    
    func getMyTodos(date: String, status: TodoStatus?) async throws -> GetMyTodosResponse {
        try await NetworkManager.shared.request(TodosRouter.getMyTodos(date: date, status: status))
    }
}
