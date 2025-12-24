//
//  ChallengeGroupsProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

protocol ChallengeGroupsProtocol {
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws
    func getMyTodos(groupId: String, date: String) async throws -> [TodoEntity]
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (index: Int, todos: [TodoEntity])
    func readTodo(todoId: String) async throws
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws
}
