//
//  GroupJoinViewController.swift
//  dogether
//
//  Created by 박지은 on 2/12/25.
//

import UIKit
import SnapKit

import Combine

final class GroupJoinViewController: BaseViewController {
    private let viewModel = GroupJoinViewModel()
    
    private let navigationHeader = NavigationHeader(title: "그룹 가입하기")
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "초대코드 입력"
        label.textColor = .grey0
        label.font = Fonts.emphasis2B
        return label
    }()
    
    private let subTitleLabel = UILabel()
    
    private let codeTextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "코드입력 (8자리)",
            attributes: [
                .foregroundColor: UIColor.grey300
            ]
        )
        textField.font = Fonts.body1S
        textField.textColor = .grey0
        textField.backgroundColor = .grey800
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.keyboardType = .asciiCapable
        textField.returnKeyType = .done
        textField.tintColor = .blue300
        textField.autocorrectionType = .no
        let paddingView = UIView()
        paddingView.frame = CGRect(x: 0, y: 0, width: 16, height: textField.frame.height)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private var joinButton = DogetherButton(title: "가입하기", status: .disabled)
    
    private var joinButtonBottomConstraint: Constraint?
    
    private var cancellables = Set<AnyCancellable>()
    private var keyboardHeight: CGFloat = 0
    private let buttonBottomInset: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        codeTextField.becomeFirstResponder()
    }
    
    override func configureView() {
        updateSubTitleLabel()
    }
    
    override func configureAction() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        navigationHeader.delegate = self
        codeTextField.delegate = self
        
        codeTextField.addAction(
            UIAction { [weak self, weak codeTextField] _ in
                guard let self, let textField = codeTextField else { return }
                viewModel.setCode(textField.text)
                textField.text = viewModel.code
                joinButton.setButtonStatus(status: viewModel.code.count < viewModel.codeLength ? .disabled : .enabled)
            },
            for: .editingChanged
        )
        
        joinButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                tryJoinGroup()
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [navigationHeader, titleLabel, subTitleLabel, codeTextField, joinButton].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationHeader.snp.bottom).offset(44)
            $0.height.equalTo(36)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(25)
        }
        
        codeTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        joinButton.snp.makeConstraints {
            joinButtonBottomConstraint = $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(buttonBottomInset).constraint
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension GroupJoinViewController {
    private func tryJoinGroup() {
        Task {
            do {
                try await viewModel.joinGroup()
                guard let groupInfo = viewModel.challengeGroupInfo else { return }
                await MainActor.run {
                    let completeViewController = CompleteViewController()
                    completeViewController.viewModel.groupType = .join
                    completeViewController.viewModel.groupInfo = groupInfo
                    coordinator?.setNavigationController(completeViewController)
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        tryJoinGroup()
                    }
                )
            }
        }
    }
}

// MARK: - Update UI
extension GroupJoinViewController {
    private func updateSubTitleLabel() {
        subTitleLabel.text = viewModel.status.text
        subTitleLabel.textColor = viewModel.status.textColor
        subTitleLabel.font = viewModel.status.font
    }
    
    private func updateCodetextField() {
        codeTextField.layer.borderColor = viewModel.status.borderColor.cgColor
    }
}

// MARK: - Keyboard
extension GroupJoinViewController {
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
                joinButtonBottomConstraint?.update(inset: adjustedKeyboardHeight + buttonBottomInset)
            } else {
                joinButtonBottomConstraint?.update(inset: buttonBottomInset)
            }
            view.layoutIfNeeded()
        }
    }
}

// MARK: - UITextFieldDelegate
extension GroupJoinViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if joinButton.isEnabled {
            joinButton.sendActions(for: .touchUpInside)
        }
        return true
    }

    private func setTextFieldBorderColor() {
        if codeTextField.isFirstResponder {
            codeTextField.layer.borderColor = UIColor.blue300.cgColor
            codeTextField.layer.borderWidth = 1.5
        } else {
            codeTextField.layer.borderColor = UIColor.clear.cgColor
            codeTextField.layer.borderWidth = 0
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setTextFieldBorderColor()
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
}
