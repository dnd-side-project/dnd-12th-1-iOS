//
//  ModalityViewModel.swift
//  dogether
//
//  Created by seungyooooong on 2/20/25.
//

import Foundation

import RxRelay

final class ModalityViewModel {
    private let todoCertificationsUseCase: TodoCertificationsUseCase
    
    private(set) var examinateViewDatas = BehaviorRelay<ExaminateViewDatas>(value: ExaminateViewDatas())
    private(set) var examinateButtonViewDatas = BehaviorRelay<DogetherButtonViewDatas>(
        value: DogetherButtonViewDatas(status: .disabled)
    )
    
    // MARK: - Computed
    var currentReview: ReviewEntity { examinateViewDatas.value.reviews[examinateViewDatas.value.index] }
    
    init() {
        let todoCertificationsRepository = DIManager.shared.getTodoCertificationsRepository()
        self.todoCertificationsUseCase = TodoCertificationsUseCase(repository: todoCertificationsRepository)
    }
    
    func setIndex(direction: Directions) {
        examinateViewDatas.update {
            $0.index = examinateViewDatas.value.index + direction.tag
        }
    }
    
    func setReviews(reviews: [ReviewEntity]) {
        examinateViewDatas.update {
            $0.index = 0
            $0.reviews = reviews
        }
    }
    
    func setResult(result: ReviewResults? = nil) {
        examinateViewDatas.update {
            $0.result = result
        }
    }
    
    func setFeedback(feedback: String = "") {
        examinateViewDatas.update {
            $0.feedback = feedback
        }
    }
    
    func setButtonStatus(status: ButtonStatus) {
        examinateButtonViewDatas.update {
            $0.status = status
        }
    }
    
    func reviewTodo() async throws {
        try await todoCertificationsUseCase.reviewTodo(
            todoId: String(currentReview.id),
            result: examinateViewDatas.value.result,
            reviewFeedback: examinateViewDatas.value.feedback
        )
    }
}
