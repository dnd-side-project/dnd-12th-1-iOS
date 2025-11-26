//
//  ModalityViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import UIKit
import SnapKit

final class ModalityViewController: BaseViewController {
    var viewModel = ModalityViewModel()
    
    // TODO: 현재는 TodoExamination 단일 종류만 존재하지만 추후 확장
    private let todoExaminationModalityView = ExaminationModalityView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        view.backgroundColor = .grey900
        
        updateView()
    }
    
    override func configureAction() {
        [todoExaminationModalityView.rejectButton, todoExaminationModalityView.approveButton].forEach { button in
            button.addAction(
                UIAction { [weak self, weak button] _ in
                    guard let self, let button,
                          let type = FilterTypes.allCases.first(where: { $0.tag == button.tag }),
                          let reviewResult = type.reviewResult else { return }
                    
                    viewModel.setResult(reviewResult)
                    viewModel.setReviewFeedback()
                    
                    todoExaminationModalityView.removeFeedback()
                    todoExaminationModalityView.updateButtonBackgroundColor(type: type)
                    // FIXME: 추후 수정
                    var viewDatas = todoExaminationModalityView.closeButton.currentViewDatas ?? DogetherButtonViewDatas(status: .disabled)
                    viewDatas.status = type == .approve ? .enabled : .disabled
                    todoExaminationModalityView.closeButton.updateView(viewDatas)
                    
                    coordinator?.showPopup(self, type: .reviewFeedback) { reviewFeedback in
                        guard let reviewFeedback = reviewFeedback as? String else { return }
                        self.viewModel.setReviewFeedback(reviewFeedback)
                        self.todoExaminationModalityView.addFeedback(feedback: reviewFeedback)
                        viewDatas.status = .enabled
                        self.todoExaminationModalityView.closeButton.updateView(viewDatas)
                    }
                }, for: .touchUpInside
            )
        }
        
        todoExaminationModalityView.closeButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                Task {
                    try await self.viewModel.reviewTodo()
                    await MainActor.run {
                        self.viewModel.setCurrent(self.viewModel.current + 1)
                        if self.viewModel.reviews.count == self.viewModel.current {
                            self.coordinator?.hideModal()
                        } else {
                            self.viewModel.setResult()
                            self.viewModel.setReviewFeedback()
                            
                            self.todoExaminationModalityView.removeFeedback()
                            self.todoExaminationModalityView.updateButtonBackgroundColor(type: .all)
                            // FIXME: 추후 수정
                            var viewDatas = self.todoExaminationModalityView.closeButton.currentViewDatas ?? DogetherButtonViewDatas(status: .disabled)
                            viewDatas.status = .disabled
                            self.todoExaminationModalityView.closeButton.updateView(viewDatas)
                            self.updateView()
                        }
                    }
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [todoExaminationModalityView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        todoExaminationModalityView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    func updateView() {
        todoExaminationModalityView.setReview(review: viewModel.reviews[viewModel.current])
    }
}
