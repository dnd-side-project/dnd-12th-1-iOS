//
//  TodoCertificationsRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 4/3/25.
//

import Foundation

final class TodoCertificationsRepositoryTest: TodoCertificationsProtocol {
    func getReviews() async throws -> [ReviewEntity] {
//        return []
        return (1...3).map {
            ReviewEntity(
                id: $0,
                content: "content \($0)",
                mediaUrl: "",
                todoContent: "todoContent \($0)",
                doer: "doer \($0)"
            )
        }
    }
    
    func reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest) async throws { }
}
