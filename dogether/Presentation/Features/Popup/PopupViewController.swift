//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

import Combine

final class PopupViewController: BaseViewController {
    var viewModel = PopupViewModel()
    
    var completion: ((Any) -> Void)?
    var pickerCompletion: ((UIImage) -> Void)?
    
    private var popupView = BasePopupView()
    
    private var popupViewCenterYConstraint: Constraint?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let popupView = popupView as? ReviewFeedbackPopupView {
            popupView.reviewFeedbackTextView.becomeFirstResponder()
        }
    }
    
    override func configureView() {
        view.backgroundColor = .grey900.withAlphaComponent(0.8)
        
        popupView = getPopupView()
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        
        popupView.delegate = self
    }
    
    override func configureHierarchy() {
        [popupView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        popupView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
            
            popupViewCenterYConstraint = $0.centerY.equalToSuperview().constraint
        }
    }
}

extension PopupViewController {
    private func getPopupView() -> BasePopupView {
        guard let popupType = viewModel.popupType else { return BasePopupView() }
        switch popupType {
        case .alert:
            guard let alertType = viewModel.alertType else { return BasePopupView() }
            let alertView = AlertPopupView(type: alertType)
            alertView.confirmButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    completion?(())
                    hidePopup()
                }, for: .touchUpInside
            )
            return alertView
            
        case .reviewFeedback:
            let reviewFeedbackPopupView = ReviewFeedbackPopupView()
            reviewFeedbackPopupView.reviewFeedbackTextView.delegate = self
            reviewFeedbackPopupView.reviewFeedbackButton.addAction(
                UIAction { [weak self] _ in
                    guard let self, let reviewFeedback = viewModel.stringContent else { return }
                    completion?(reviewFeedback)
                    hidePopup()
                }, for: .touchUpInside
            )
            return reviewFeedbackPopupView
        }
    }
}

extension PopupViewController: PopupDelegate {
    func hidePopup() {
        coordinator?.hidePopup()
    }
}

extension PopupViewController {
    @objc private func dismissPopup() {
        hidePopup()
    }
}

// MARK: - about keyboard
extension PopupViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        guard let textView = textView as? DogetherTextView else { return false }
        let currentText = textView.text ?? ""
        
        guard let textRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        
        return updatedText.count <= textView.type.maxLength
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? DogetherTextView else { return }
        textView.updateTextInfo()
        viewModel.setStringContent(textView.text)
        
        if let popupView = popupView as? ReviewFeedbackPopupView, textView.text.count > 0 {
            popupView.reviewFeedbackButton.setButtonStatus(status: .enabled)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOn()
        
        if let popupView = popupView as? ReviewFeedbackPopupView {
            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOff()
        
        if let popupView = popupView as? ReviewFeedbackPopupView {
            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        }
        return true
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                guard let userInfo = notification.userInfo,
                      let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                    return nil
                }
                return frameValue.cgRectValue.height
            }
            .sink { [weak self] height in
                guard let self else { return }
                updateUIForKeyboard(keyboardHeight: height)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                updateUIForKeyboard(keyboardHeight: 0)
            }
            .store(in: &cancellables)
    }
    
    private func updateUIForKeyboard(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.35) { [weak self] in
            guard let self = self else { return }
            
            let safeAreaTop = view.safeAreaInsets.top
            let safeAreaHeight = view.frame.height - keyboardHeight - safeAreaTop
            let newCenterY = safeAreaTop + safeAreaHeight / 2
            
            popupViewCenterYConstraint?.update(offset: newCenterY - view.bounds.midY)
            
            view.layoutIfNeeded()
        }
    }
}
