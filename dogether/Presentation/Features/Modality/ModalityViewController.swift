//
//  ModalityViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class ModalityViewController: BaseViewController {
    private let examinatePage = ExaminatePage()
    private let viewModel = ModalityViewModel()
    
    override func viewDidLoad() {
        examinatePage.delegate = self
        
        pages = [examinatePage]

        super.viewDidLoad()
    }
    
    override func setViewDatas() {
        if let datas = datas as? ExaminateViewDatas {
            viewModel.examinateViewDatas.accept(datas)
        }
        
        bind(viewModel.examinateViewDatas)
        bind(viewModel.examinateButtonViewDatas)
    }
}

protocol ExaminateDelegate {
    func updateReviewsAction(reviews: [ReviewEntity])
    func examinateAction(type: FilterTypes)
    func sendAction()
}

extension ModalityViewController: ExaminateDelegate {
    func updateReviewsAction(reviews: [ReviewEntity]) {
        viewModel.setReviews(reviews: reviews)
    }
    
    func examinateAction(type: FilterTypes) {
        viewModel.setResult(result: type.reviewResult)
        viewModel.setFeedback()
        viewModel.setButtonStatus(status: type == .approve ? .enabled : .disabled)

        coordinator?.showPopup(type: .examinate) { [weak self] reviewFeedback in
            guard let self, let reviewFeedback = reviewFeedback as? String else { return }
            viewModel.setFeedback(feedback: reviewFeedback)
            viewModel.setButtonStatus(status: .enabled)
        }
    }
    
    func sendAction() {
        Task {
            try await viewModel.reviewTodo()
            await MainActor.run {
                if viewModel.examinateViewDatas.value.reviews.count == viewModel.examinateViewDatas.value.index + 1 {
                    coordinator?.hideModal()
                } else {
                    viewModel.setIndex(direction: .next)
                    viewModel.setResult()
                    viewModel.setFeedback()
                    viewModel.setButtonStatus(status: .disabled)
                }
            }
        }
    }
}
