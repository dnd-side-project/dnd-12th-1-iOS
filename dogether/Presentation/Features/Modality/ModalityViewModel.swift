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
    private(set) var reviewFeedback: String = ""
    
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
    
    func setReviewFeedback(_ reviewFeedback: String = "") {
        self.reviewFeedback = reviewFeedback
    }
    
    func reviewTodo() async throws {
        try await todoCertificationsUseCase.reviewTodo(
            todoId: String(reviews[current].id), result: result, reviewFeedback: reviewFeedback
        )
    }
}
