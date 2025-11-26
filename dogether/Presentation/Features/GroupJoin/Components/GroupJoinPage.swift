//
//  GroupJoinPage.swift
//  dogether
//
//  Created by seungyooooong on 11/19/25.
//

import UIKit
import SnapKit

final class GroupJoinPage: BasePage {
    var delegate: GroupJoinDelegate? {
        didSet {
            codeTextField.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    let code = String((codeTextField.text ?? "").prefix(codeMaxLength))
                    codeTextField.text = code
                    delegate?.updateCodeAction(code: code, codeMaxLength: codeMaxLength)
                },
                for: .editingChanged
            )
            
            joinButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.joinGroupAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "그룹 가입하기")
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let codeTextField = UITextField()
    private var joinButton = DogetherButton("가입하기")
    
    private let codeMaxLength = 8
    
    private var currentStatus: GroupJoinStatus?
    private var currentKeyboardHeight: CGFloat?
    private var currentIsFirstResponder: Bool?
    private var isFirst: Bool = true
    
    override func configureView() {
        titleLabel.text = "초대코드 입력"
        titleLabel.textColor = .grey0
        titleLabel.font = Fonts.emphasis2B
        
        codeTextField.attributedPlaceholder = NSAttributedString(
            string: "코드입력 (8자리)",
            attributes: [.foregroundColor: UIColor.grey300]
        )
        codeTextField.font = Fonts.body1S
        codeTextField.textColor = .grey0
        codeTextField.backgroundColor = .grey800
        codeTextField.layer.cornerRadius = 12
        codeTextField.layer.masksToBounds = true
        codeTextField.keyboardType = .asciiCapable
        codeTextField.returnKeyType = .done
        codeTextField.tintColor = .blue300
        codeTextField.autocorrectionType = .no
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: codeTextField.frame.height))
        codeTextField.leftView = leftPaddingView
        codeTextField.leftViewMode = .always
    }
    
    override func configureAction() {
        addTapAction { [weak self] _ in
            guard let self else { return }
            endEditing(true)
        }
        
        navigationHeader.delegate = coordinatorDelegate
        
        codeTextField.delegate = self
        observeKeyboardNotifications()
    }
    
    override func configureHierarchy() {
        [navigationHeader, titleLabel, subTitleLabel, codeTextField, joinButton].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationHeader.snp.bottom).offset(40)
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
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? GroupJoinViewDatas {
            if currentStatus != datas.status {
                currentStatus = datas.status
                
                subTitleLabel.text = datas.status.text
                subTitleLabel.textColor = datas.status.textColor
                subTitleLabel.font = datas.status.font
                
                codeTextField.layer.borderColor = datas.status.borderColor.cgColor
            }
            
            // MARK: subTitleLabel 등 일반 UI의 구성을 최초 진행, 이후 joinButton 애니메이션을 위해 위치 조정
            if isFirst {
                isFirst = false
                
                layoutIfNeeded()
            }
            
            if currentKeyboardHeight != datas.keyboardHeight {
                currentKeyboardHeight = datas.keyboardHeight
                
                joinButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(datas.keyboardHeight)
                }
                UIView.animate(withDuration: 0.35) { [weak self] in
                    guard let self else { return }
                    layoutIfNeeded()
                }
            }
            
            if currentIsFirstResponder != datas.isFirstResponder {
                currentIsFirstResponder = datas.isFirstResponder
                
                if datas.isFirstResponder { codeTextField.becomeFirstResponder() }
            }
        }
        
        if let datas = data as? DogetherButtonViewDatas {
            joinButton.updateView(datas)
        }
    }
}

// MARK: - Keyboard
extension GroupJoinPage {
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        delegate?.updateKeyboardHeightAction(height: frame.height - UIApplication.safeAreaOffset.bottom + 16)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        delegate?.updateKeyboardHeightAction(height: 16)
    }
}

// MARK: - UITextFieldDelegate
extension GroupJoinPage: UITextFieldDelegate {
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
}
