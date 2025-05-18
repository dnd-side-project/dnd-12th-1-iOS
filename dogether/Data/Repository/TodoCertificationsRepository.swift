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
    
    func getReviews() async throws -> GetReviewsResponse {
        try await todoCertificationsDataSource.getReviews()
    }
    
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws {
        try await todoCertificationsDataSource.reviewTodo(todoId: todoId, reviewTodoRequest: reviewTodoRequest)
    }
}
