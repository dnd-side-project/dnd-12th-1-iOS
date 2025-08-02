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
    
    func createTodos(groupId: Int, todos: [WriteTodoInfo]) async throws {
        let createTodosRequest = CreateTodosRequest(todos: todos.filter { $0.enabled }.map { $0.content })
        try await repository.createTodos(groupId: String(groupId), createTodosRequest: createTodosRequest)
    }
    
    func getMyTodos(groupId: Int, date: String) async throws -> [TodoInfo] {
        let response = try await repository.getMyTodos(groupId: String(groupId), date: date)
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
                feedback: $0.reviewFeedback,
                thumbnailStatus: $0.isRead ? .done : .yet
            )
        }
        return (currentIndex, memberTodos)
    }
    
    func readTodo(todo: MemberCertificationInfo) async throws {
        if todo.thumbnailStatus == .done { return }
        try await repository.readTodo(todoId: String(todo.id))
    }
    
    func certifyTodo(todoId: Int, content: String, mediaUrl: String) async throws {
        let certifyTodoRequest = CertifyTodoRequest(content: content, mediaUrl: mediaUrl)
        try await repository.certifyTodo(todoId: String(todoId), certifyTodoRequest: certifyTodoRequest)
    }
}
