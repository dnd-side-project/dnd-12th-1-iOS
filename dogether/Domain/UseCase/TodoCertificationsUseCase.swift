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
    
    func getReviews() async throws -> [ReviewEntity] {
        return try await repository.getReviews()
    }
    
    func reviewTodo(todoId: String, result: ReviewResults?, reviewFeedback: String) async throws {
        guard let result else { return }
        let reviewTodoRequest = ReviewTodoRequest(result: result, reviewFeedback: reviewFeedback)
        try await repository.reviewTodo(todoId: todoId, reviewTodoRequest: reviewTodoRequest)
    }
    
}
