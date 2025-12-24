//
//  TodoCertificationsRepository.swift
//  dogether
//
//  Created by seungyooooong on 4/3/25.
//

import Foundation

final class TodoCertificationsRepository: TodoCertificationsProtocol {
    private let todoCertificationsDataSource: TodoCertificationsDataSource
    
    init(todoCertificationsDataSource: TodoCertificationsDataSource = .shared) {
        self.todoCertificationsDataSource = todoCertificationsDataSource
    }
    
    func getReviews() async throws -> [ReviewEntity] {
        let response = try await todoCertificationsDataSource.getReviews()
        return response.dailyTodoCertifications.map {
            ReviewEntity(
                id: $0.id,
                content: $0.content,
                mediaUrl: $0.mediaUrl,
                todoContent: $0.todoContent,
                doer: $0.doer
            )
        }
    }
    
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws {
        try await todoCertificationsDataSource.reviewTodo(todoId: todoId, reviewTodoRequest: reviewTodoRequest)
    }
}
