//
//  CertificationSupplyViewController.swift
//  dogether
//
//  Created by seungyooooong on 5/13/25.
//

import UIKit
import SnapKit

import Combine

final class CertificationSupplyViewController: BaseViewController {
    var viewModel = CertificationViewModel()
    
    private let navigationHeader = NavigationHeader(title: "인증 하기")
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "인증 내용을 보완해주세요!"
        label.textColor = .grey0
        label.textAlignment = .center
        label.font = Fonts.head1B
        return label
    }()
    
    private let descriptionView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "한번 인증한 내용은 바꿀 수 없어요"
        label.textColor = .grey400
        label.font = Fonts.body2S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        [stackView].forEach { view.addSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        return view
    }()
    
    private let certificationTextView = DogetherTextView(type: .certification)
    
    private let certificationButton = DogetherButton(title: "인증하기", status: .disabled)
    
    private var certificationButtonBottomConstraint: Constraint?
    
    private var cancellables = Set<AnyCancellable>()
    private var keyboardHeight: CGFloat = 0
    private let buttonBottomInset: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        certificationTextView.becomeFirstResponder()
    }
    
    override func configureView() {
        
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        certificationTextView.delegate = self
        
        certificationButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                tryCertifyTodo()
            }, for: .touchUpInside
        )

    }
    
    override func configureHierarchy() {
        [ navigationHeader,
          descriptionLabel, descriptionView, certificationTextView,
          certificationButton
        ].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationHeader.snp.bottom).offset(32)
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            $0.height.equalTo(25)
        }
        
        certificationTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(106)
        }
        
        certificationButton.snp.makeConstraints {
            certificationButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(buttonBottomInset).constraint
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
// MARK: - Keyboard
extension CertificationSupplyViewController {
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
                keyboardHeight = height
                updateUIForKeyboard()
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                keyboardHeight = 0
                updateUIForKeyboard()
            }
            .store(in: &cancellables)
    }
    
    private func updateUIForKeyboard() {
        UIView.animate(withDuration: 0.35) { [weak self] in
            guard let self = self else { return }
            let safeAreaBottom = view.safeAreaInsets.bottom
            let adjustedKeyboardHeight = max(keyboardHeight - safeAreaBottom, 0)
            if keyboardHeight > 0 {
                certificationButtonBottomConstraint?.update(inset: adjustedKeyboardHeight + buttonBottomInset)
            } else {
                certificationButtonBottomConstraint?.update(inset: buttonBottomInset)
            }
            view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension CertificationSupplyViewController: UITextViewDelegate {
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
        viewModel.setText(textView.text)
        certificationButton.setButtonStatus(
            status: textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .disabled
            : .enabled
        )
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOn()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let textView = textView as? DogetherTextView else { return false }
        textView.focusOff()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        return true
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}

extension CertificationSupplyViewController {
    private func tryCertifyTodo() {
        Task {
            do {
                try await self.viewModel.certifyTodo()
                
                // FIXME: certifyTodo 함수 안에서 에러 케이스 핸들링 하시면서 수정해주세요, 아래 3라인은 성공했을 때 액션입니다
                await MainActor.run {
                    self.coordinator?.popViewControllers(num: 2)
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: self.coordinator,
                    retryHandler: { [weak self] in
                        self?.tryCertifyTodo()
                    }
                )
            }
        }
    }
}
