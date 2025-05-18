//
//  ChallengeGroupUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupUseCase {
    private let repository: ChallengeGroupsProtocol
    
    init(repository: ChallengeGroupsProtocol) {
        self.repository = repository
    }
    
    func createTodos(groupId: Int, todos: [String]) async throws {
        let createTodosRequest = CreateTodosRequest(todos: todos)
        try await repository.createTodos(groupId: String(groupId), createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(groupId: Int, date: String, status: TodoStatus?) async throws -> [TodoInfo] {
        let response = try await repository.getMyTodos(groupId: String(groupId), date: date, status: status?.rawValue)
        return response.todos
    }
    
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (currentIndex: Int, memberTodos: [MemberCertificationInfo]) {
        let response = try await repository.getMemberTodos(groupId: String(groupId), memberId: String(memberId))
        let currentIndex = response.currentTodoHistoryToReadIndex
        let memberTodos = response.todos.map {
            MemberCertificationInfo(
                id: $0.id,
                content: $0.content,
                status: TodoStatus(rawValue: $0.status) ?? .waitExamination,
                certificationContent: $0.certificationContent,
                certificationMediaUrl: $0.certificationMediaUrl,
                thumbnailStatus: $0.isRead ? .done : .yet)
        }
        return (currentIndex, memberTodos)
    }
    
    func readTodo(todoId: Int) async throws {
        try await repository.readTodo(todoId: String(todoId))
    }
}
