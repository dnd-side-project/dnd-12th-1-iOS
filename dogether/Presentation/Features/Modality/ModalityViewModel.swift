//
//  ModalityViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/20/25.
//

import Foundation

final class ModalityViewModel {
    private let todoCertificationsUseCase: TodoCertificationsUseCase
    
    private(set) var reviews: [ReviewModel] = []
    private(set) var current: Int = 0
    private(set) var result: ReviewResults? = nil
    private(set) var rejectReason: String = ""
    
    init() {
        let todoCertificationsRepository = DIManager.shared.getTodoCertificationsRepository()
        self.todoCertificationsUseCase = TodoCertificationsUseCase(repository: todoCertificationsRepository)
    }
    
    func setReviews(_ reviews: [ReviewModel]?) {
        guard let reviews else { return }
        self.reviews = reviews
        self.current = 0
    }
    
    func setCurrent(_ current: Int) {
        self.current = current
    }
    
    func setResult(_ result: ReviewResults? = nil) {
        self.result = result
    }
    
    func setRejectReason(_ rejectReason: String = "") {
        self.rejectReason = rejectReason
    }
    
    func reviewTodo() async throws {
        guard let result else { return }
        let reviewTodoRequest = ReviewTodoRequest(result: result, rejectReason: result == .reject ? rejectReason : nil)
        try await todoCertificationsUseCase.reviewTodo(todoId: String(reviews[current].id), reviewTodoRequest: reviewTodoRequest)
    }
}
