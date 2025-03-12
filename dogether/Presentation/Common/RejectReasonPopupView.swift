//
//  RejectReasonPopupView.swift
//  dogether
//
//  Created by seungyooooong on 2/17/25.
//

import Foundation
import UIKit
import SnapKit

final class RejectReasonPopupView: UIView {
    private let rejectReasonMaxLength = 60
    
    /// 완료된 텍스트뷰 텍스트
    private let completeAction: (String) -> Void
    
    /// 뒤로가기 액션
    private let dismissAction: () -> Void
    
    init(
        completeAction: @escaping (String) -> Void,
        dismissAction: @escaping () -> Void
    ) {
        self.completeAction = completeAction
        self.dismissAction = dismissAction
        super.init(frame: .zero)
        setUI()
        setupKeyboardHandling()
    }
    
    required init?(coder: NSCoder) {
        logger.error("\(#file) can not init(coder:)")
        fatalError()
    }
    
    private let closeButton = UIButton()
        .setOf {
            $0.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .grey0
        }
    
    private let descriptionLabel = UILabel()
        .setOf {
            $0.text = "이유를 들려주세요 !"
            $0.textColor = .grey0
            $0.textAlignment = .center
            $0.font = Fonts.head1B
        }
    
    private let descriptionView = UIView()
        .setOf { descriptionView in
            descriptionView.layer.cornerRadius = 8
            descriptionView.layer.borderColor = UIColor.grey600.cgColor
            descriptionView.layer.borderWidth = 1
            
            let imageView = UIImageView(image: .notice)
            
            let label = UILabel()
            label.text = "한번 등록한 피드백은 바꿀 수 없어요"
            label.textColor = .grey400
            label.font = Fonts.body2S
                
            let stackView = UIStackView(arrangedSubviews: [imageView, label])
            stackView.axis = .horizontal
            stackView.spacing = 8
            
            descriptionView.addSubview(stackView)
            
            stackView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            imageView.snp.makeConstraints {
                $0.width.height.equalTo(24)
            }
        }
    
    private let rejectReasonView = UIView()
        .setOf {
            $0.backgroundColor = .grey800
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.blue300.cgColor
            $0.layer.borderWidth = 1
        }
    
    private let rejectReasonPlaceHolderLabel = UILabel()
        .setOf {
            $0.textColor = .grey300
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
    
    private func rejectReasonTextView(tempParameter: Bool = false) -> UITextView {
        let textView = UITextView()
        textView.text = ""
        textView.textColor = .grey50
        textView.font = Fonts.body1R
        textView.tintColor = .blue300
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.delegate = self
        return textView
    }
    
    private var rejectReasonTextView = UITextView()
    
    private let rejectReasonTextCountLabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .blue300
        label.font = Fonts.smallS
        return label
    }()
    
    private let rejectReasonMaxLengthLabel = {
        let label = UILabel()
        label.textColor = .grey400
        label.font = Fonts.smallS
        return label
    }()
    
    private var rejectReasonButton = DogetherButton(title: "등록하기", status: .disabled)
    
}

// MARK: UI
extension RejectReasonPopupView: BaseViewProtocol {
    
    private func setUI() {
        
        let _rejectButton = DogetherButton(title: "등록하기", status: .disabled) { [weak self] in
            guard let self else { return }
            completeAction(rejectReasonTextView.text)
        }
        
        self.rejectReasonButton = _rejectButton
        
        configureHierarchy()
        configureConstraints()
        configureView()
    }
    
    
    func configureHierarchy() {
        [ closeButton, descriptionLabel, descriptionView,
          rejectReasonView, rejectReasonPlaceHolderLabel, rejectReasonTextView,
          rejectReasonTextCountLabel, rejectReasonMaxLengthLabel,
          rejectReasonButton
        ].forEach {
            addSubview($0)
        }
    }
    
    func configureConstraints() {
        self.snp.updateConstraints {
            $0.height.equalTo(422)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        rejectReasonView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(160)
        }
        
        rejectReasonPlaceHolderLabel.snp.makeConstraints {
            $0.top.equalTo(rejectReasonView).offset(16)
            $0.horizontalEdges.equalTo(rejectReasonView).inset(16)
            $0.width.equalTo(271)
        }
        
        rejectReasonTextView.snp.makeConstraints {
            $0.top.equalTo(rejectReasonView).offset(22)
            $0.horizontalEdges.equalTo(rejectReasonView).inset(16)
            $0.width.equalTo(271)
            $0.height.equalTo(100)
        }
        
        rejectReasonTextCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(rejectReasonView).inset(16)
            $0.right.equalTo(rejectReasonMaxLengthLabel.snp.left)
            $0.height.equalTo(18)
        }
        
        rejectReasonMaxLengthLabel.snp.makeConstraints {
            $0.bottom.equalTo(rejectReasonView).inset(16)
            $0.right.equalTo(rejectReasonView).inset(16)
            $0.height.equalTo(18)
        }
        
        rejectReasonButton.snp.makeConstraints {
            $0.top.equalTo(rejectReasonView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
    
    func configureView() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
        
        rejectReasonPlaceHolderLabel.attributedText = NSAttributedString(
            string: "팀원이 이해하기 쉽도록 인증에 대한 설명을 입력하세요.",
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .left)
        )
        rejectReasonTextView = rejectReasonTextView()
        rejectReasonTextView.becomeFirstResponder()
        rejectReasonMaxLengthLabel.text = "/\(rejectReasonMaxLength)"
    }
}

// MARK: ActionSettings
extension RejectReasonPopupView {
    
    /// 닫기 버튼을 세팅합니다.
    private func closeButtonActionSetting() {
        let action = UIAction { [weak self] _ in
            self?.dismissAction()
        }
        closeButton.addAction(action, for: .touchUpInside)
    }
    
}

// MARK: - abount keyboard
extension RejectReasonPopupView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if text.count > rejectReasonMaxLength {
                textView.text = String(text.prefix(rejectReasonMaxLength))
            }
            rejectReasonPlaceHolderLabel.isHidden = text.count > 0
            rejectReasonTextCountLabel.text = String(textView.text.count)
            rejectReasonButton.setButtonStatus(status: text.count > 0 ? .enabled : .disabled)
        }
    }
    
    private func setupKeyboardHandling() {
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
    
    // MARK: - UITextFieldDelegate
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        self.snp.updateConstraints { $0.centerY.equalToSuperview().offset(-keyboardHeight / 2) }
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.snp.updateConstraints { $0.centerY.equalToSuperview() }
        UIView.animate(withDuration: 0.3) { self.layoutIfNeeded() }
    }
}
