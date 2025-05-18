//
//  PopupViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit
import SnapKit

final class PopupViewController: BaseViewController {
    var viewModel = PopupViewModel()
    
    var completion: ((Any) -> Void)?
    var pickerCompletion: ((UIImage) -> Void)?
    
    private var popupView = BasePopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
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
            
        case .rejectReason:
            let rejectReasonPopupView = RejectReasonPopupView()
            rejectReasonPopupView.rejectReasonTextView.delegate = self
            rejectReasonPopupView.rejectReasonButton.addAction(
                UIAction { [weak self] _ in
                    guard let self, let rejectReason = viewModel.stringContent else { return }
                    completion?(rejectReason)
                    hidePopup()
                }, for: .touchUpInside
            )
            return rejectReasonPopupView
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
        
        if let popupView = popupView as? RejectReasonPopupView, textView.text.count > 0 {
            popupView.rejectReasonButton.setButtonStatus(status: .enabled)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOn()
        
        if let popupView = popupView as? RejectReasonPopupView {
            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOff()
        
        if let popupView = popupView as? RejectReasonPopupView {
            popupView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        }
        return true
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
