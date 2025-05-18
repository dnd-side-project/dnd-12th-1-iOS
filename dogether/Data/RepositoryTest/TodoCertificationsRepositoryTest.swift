//
//  TodoCertificationsRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 4/3/25.
//

import Foundation

final class TodoCertificationsRepositoryTest: TodoCertificationsProtocol {
    func getReviews() async throws -> GetReviewsResponse {
//        return GetReviewsResponse(dailyTodoCertifications: [])
        let dailyTodoCertifications = (1...3).map {
            ReviewModel(id: $0, content: "content \($0)", mediaUrl: "", todoContent: "todoContent \($0)", doer: "doer \($0)")
        }
        return GetReviewsResponse(dailyTodoCertifications: dailyTodoCertifications)
    }
    
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws { }
}
