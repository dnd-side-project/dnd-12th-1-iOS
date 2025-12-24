//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

final class PopupViewController: BaseViewController {
    private let popupPage = PopupPage()
    private let viewModel = PopupViewModel()
    
    // FIXME: 추후 수정
    var completion: ((Any) -> Void)?
    
    override func viewDidLoad() {
        popupPage.delegate = self
        
        pages = [popupPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.updateIsFirstResponder(isFirstResponder: true)
    }
    
    override func setViewDatas() {
        if let datas = datas as? AlertPopupViewDatas {
            viewModel.alertPopupViewDatas.accept(datas)
            bind(viewModel.alertPopupViewDatas)
        }
        
        if let datas = datas as? ExaminatePopupViewDatas {
            viewModel.examinatePopupViewDatas.accept(datas)
            bind(viewModel.examinatePopupViewDatas)
            bind(viewModel.examinateTextViewDatas)
            bind(viewModel.registerButtonViewDatas)
        }
    }
}

extension PopupViewController {
    private func onAppear() {
        // MARK: - setup for popup ui
        // FIXME: 추후 수정
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        view.addTapAction { [weak self] _ in
            guard let self else { return }
            hidePopup()
        }
        pages?.forEach { page in
            page.snp.remakeConstraints {
                $0.centerX.equalTo(view)
                $0.centerY.equalTo(view)
                $0.horizontalEdges.equalTo(view).inset(16)
            }
        }
    }
}

protocol PopupDelegate {
    func completeAction()
    func hidePopup()
    func updateKeyboardHeightAction(height: CGFloat)
    func updateFeedbackAction(feedback: String)
}

extension PopupViewController: PopupDelegate {
    func completeAction() {
        let param: Any = viewModel.examinatePopupViewDatas.value?.feedback as Any
        completion?(param)
    }
    
    func hidePopup() {
        coordinator?.hidePopup()
    }
    
    func updateKeyboardHeightAction(height: CGFloat) {
        let safeAreaTop = view.safeAreaInsets.top
        let safeAreaHeight = view.frame.height - height - safeAreaTop
        let newCenterY = safeAreaTop + safeAreaHeight / 2
        
        pages?.forEach { page in
            page.snp.updateConstraints {
                $0.centerY.equalTo(view).offset(newCenterY - view.bounds.midY)
            }
        }
        
        UIView.animate(withDuration: 0.35) { [weak self] in
            guard let self else { return }
            view.layoutIfNeeded()
        }
        
        viewModel.updateIsFirstResponder(isFirstResponder: height > 0)
    }
    
    func updateFeedbackAction(feedback: String) {
        viewModel.updateFeedback(feedback: feedback)
    }
}
