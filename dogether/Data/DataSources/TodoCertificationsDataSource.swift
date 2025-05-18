//
//  TodoCertificationsDataSource.swift
//  dogether
//
//  Created by seungyooooong on 4/3/25.
//

import Foundation

final class TodoCertificationsDataSource {
    static let shared = TodoCertificationsDataSource()
    
    private init() { }
    
    func getReviews() async throws -> GetReviewsResponse{
        try await NetworkManager.shared.request(TodoCertificationsRouter.getReviews)
    }
    
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws {
        try await NetworkManager.shared.request(
            TodoCertificationsRouter.reviewTodo(todoId: todoId, reviewTodoRequest: reviewTodoRequest)
        )
    }
}
