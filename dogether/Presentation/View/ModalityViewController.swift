//
//  ModalityViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import Foundation
import UIKit
import SnapKit

final class ModalityViewController: BaseViewController {
    var viewModel = ModalityViewModel()
    
    // TODO: 현재는 TodoExamination 단일 종류만 존재하지만 추후 확장
    private let backgroundView = UIView()
        .setOf {
            $0.backgroundColor = .grey900.withAlphaComponent(0.8)
        }
    
    private let titlaLabel = UILabel()
        .setOf {
            $0.text = "투두를 검사해주세요!"
            $0.textColor = .grey0
            $0.font = Fonts.head1B
        }
    
    private var todoExaminationModalityView = UIView()
    
    private var closeButton = DogetherButton(title: "보내기", status: .disabled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
//        closeButton.action = didTapCloseButton
        
        closeButton.buttonTapped = { [weak self] in
            self?.didTapCloseButton()
        }
        
        todoExaminationModalityView = ExaminationModalityView(buttonAction: { [weak self] type in
            guard let weakSelf = self else { return }
            switch type {
            case .reject:
                weakSelf.viewModel.setResult(.reject)
                weakSelf.viewModel.setRejectReason()
                weakSelf.closeButton.setButtonStatus(status: .disabled)
                
                weakSelf.showPopup(type: .rejectReason, completeAction:  { rejectReason in
                    weakSelf.viewModel.setRejectReason(rejectReason)
                    weakSelf.closeButton.setButtonStatus(status: .enabled)
                })
//                PopupManager.shared.showPopup(type: .rejectReason, completeAction: { rejectReason in
//                    self.viewModel.setRejectReason(rejectReason)
//                    self.closeButton.setButtonStatus(status: .enabled)
//                })
                
            case .approve:
                weakSelf.viewModel.setResult(.approve)
                weakSelf.closeButton.setButtonStatus(status: .enabled)
                
            default:
                return
            }
        }, review: viewModel.reviews[viewModel.current])
    }
    
    override func configureHierarchy() {
        [backgroundView, titlaLabel, todoExaminationModalityView, closeButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titlaLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            $0.height.equalTo(36)
        }
        
        todoExaminationModalityView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
    
    private func didTapCloseButton() {
        Task { @MainActor in
            try await viewModel.reviewTodo()
            // TODO: 검사 할 투두가 여러개일 때 다음 투두로 넘어가는 기능은 추후 구현
//            viewModel.setCurrent(viewModel.current + 1)
//            if viewModel.reviews.count == viewModel.current {
                ModalityManager.shared.dismiss()
//            } else {
//                viewModel.setResult()
//                viewModel.setRejectReason()
//                configureView() // TODO: 추후 확인
//            }
        }
    }
}
