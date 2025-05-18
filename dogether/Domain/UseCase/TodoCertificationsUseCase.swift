//
//  TodoCertificationsUseCase.swift
//  dogether
//
//  Created by seungyooooong on 4/3/25.
//

import Foundation

final class TodoCertificationsUseCase {
    private let repository: TodoCertificationsProtocol
    
    init(repository: TodoCertificationsProtocol) {
        self.repository = repository
    }
    
    func getReviews() async throws -> [ReviewModel] {
        let response = try await repository.getReviews()
        return response.dailyTodoCertifications
    }
    
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws {
        try await repository.reviewTodo(todoId: todoId, reviewTodoRequest: reviewTodoRequest)
    }
}
