//
//  TodoCertificationsProtocol.swift
//  dogether
//
//  Created by seungyooooong on 4/3/25.
//

import Foundation

protocol TodoCertificationsProtocol {
    func getReviews() async throws -> GetReviewsResponse
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws
}
