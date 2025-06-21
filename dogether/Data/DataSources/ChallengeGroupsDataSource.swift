//
//  ChallengeGroupsDataSource.swift
//  dogether
//
//  Created by seungyooooong on 3/8/25.
//

import Foundation

final class ChallengeGroupsDataSource {
    static let shared = ChallengeGroupsDataSource()
    
    private init() { }
    
    func getMyTodos(groupId: String, date: String) async throws -> GetMyTodosResponse {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.getMyTodos(groupId: groupId, date: date))
    }
    
    func getMemberTodos(groupId: String, memberId: String) async throws -> GetMemberTodosResponse {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.getMemberTodos(groupId: groupId, memberId: memberId))
    }
    
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.createTodos(groupId: groupId, createTodosRequest: createTodosRequest))
    }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest))
    }
    
    func readTodo(todoId: String) async throws {
        try await NetworkManager.shared.request(ChallengeGroupsRouter.readTodo(todoId: todoId))
    }
}
