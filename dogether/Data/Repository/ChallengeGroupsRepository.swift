//
//  ChallengeGroupsRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/30/25.
//

import Foundation

final class ChallengeGroupsRepository: ChallengeGroupsProtocol {
    private let challengeGroupsDataSource: ChallengeGroupsDataSource
    
    init(challengeGroupsDataSource: ChallengeGroupsDataSource = .shared) {
        self.challengeGroupsDataSource = challengeGroupsDataSource
    }
    
    func createTodos(groupId: String, createTodosRequest: CreateTodosRequest) async throws {
        try await challengeGroupsDataSource.createTodos(groupId: groupId, createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(groupId: String, date: String) async throws -> [TodoEntity] {
        let response = try await challengeGroupsDataSource.getMyTodos(groupId: groupId, date: date)
        return response.todos.map {
            TodoEntity(
                id: $0.id,
                content: $0.content,
                status: TodoStatus(rawValue: $0.status) ?? .waitCertification,
                certificationContent: $0.certificationContent,
                certificationMediaUrl: $0.certificationMediaUrl,
                reviewFeedback: $0.reviewFeedback
            )
        }
    }
    
    func getMemberTodos(groupId: Int, memberId: Int) async throws -> (index: Int, todos: [TodoEntity]) {
        let response = try await challengeGroupsDataSource.getMemberTodos(
            groupId: String(groupId), memberId: String(memberId)
        )
        
        let currentIndex = response.currentTodoHistoryToReadIndex
        let memberTodos = response.todos.map {
            TodoEntity(
                id: $0.id,
                content: $0.content,
                status: TodoStatus(rawValue: $0.status) ?? .waitCertification,
                thumbnailStatus: $0.isRead ? .done : .yet,
                certificationContent: $0.certificationContent,
                certificationMediaUrl: $0.certificationMediaUrl,
                reviewFeedback: $0.reviewFeedback
            )
        }
        return (currentIndex, memberTodos)
    }
    
    func readTodo(todoId: String) async throws {
        try await challengeGroupsDataSource.readTodo(todoId: todoId)
    }
    
    func certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest) async throws {
        try await challengeGroupsDataSource.certifyTodo(todoId: todoId, certifyTodoRequest: certifyTodoRequest)
    }
}
