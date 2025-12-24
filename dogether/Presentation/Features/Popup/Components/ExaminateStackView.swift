//
//  ExaminateStackView.swift
//  dogether
//
//  Created by seungyooooong on 12/7/25.
//

import UIKit

final class ExaminateStackView: BaseStackView {
    var delegate: PopupDelegate? {
        didSet {
            closeButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.hidePopup()
                }, for: .touchUpInside
            )
            
            registerButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.hidePopup()
                    delegate?.completeAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let closeContainerView = UIView()
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let descriptionView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        
        let imageView = UIImageView(image: .notice.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .grey400
        
        let label = UILabel()
        label.text = "검사가 완료된 피드백은 바꿀 수 없어요"
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
            $0.size.equalTo(16)
        }
        
        return view
    }()
    private let examinateTextView = DogetherTextView(type: .examination)
    private let registerButton = DogetherButton("등록하기")
    
    private(set) var currentIsFirstResponder: Bool?
    
    override func configureView() {
        axis = .vertical
        
        closeButton.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.tintColor = .grey0
        
        titleLabel.text = "이유를 들려주세요 !"
        titleLabel.textColor = .grey0
        titleLabel.textAlignment = .center
        titleLabel.font = Fonts.head1B
    }
    
    override func configureAction() {
        examinateTextView.delegate = self
        observeKeyboardNotifications()
    }
     
    override func configureHierarchy() {
        [closeButton].forEach { closeContainerView.addSubview($0) }
        
        [ closeContainerView, titleLabel, descriptionView,
          examinateTextView, registerButton
        ].forEach { addArrangedSubview($0) }
        
        setCustomSpacing(12, after: titleLabel)
        setCustomSpacing(20, after: descriptionView)
        setCustomSpacing(24, after: examinateTextView)
    }
     
    override func configureConstraints() {
        closeContainerView.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        
        closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        examinateTextView.snp.makeConstraints {
            $0.height.equalTo(135)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? ExaminatePopupViewDatas {
            if currentIsFirstResponder != datas.isFirstResponder {
                currentIsFirstResponder = datas.isFirstResponder
                
                if datas.isFirstResponder { examinateTextView.becomeFirstResponder() }
            }
        }
        
        if let datas = data as? DogetherTextViewDatas {
            examinateTextView.updateView(datas)
        }
        
        if let datas = data as? DogetherButtonViewDatas {
            registerButton.updateView(datas)
        }
    }
}

// MARK: - Keyboard
extension ExaminateStackView {
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
        delegate?.updateKeyboardHeightAction(height: frame.height)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        delegate?.updateKeyboardHeightAction(height: 0)
    }
}

// MARK: - UITextFieldDelegate
extension ExaminateStackView: UITextViewDelegate {
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
        
//        let feedback = String((textView.text ?? "").prefix(textView.type.maxLength))
//        textView.text = feedback
//        delegate?.updateFeedbackAction(feedback: feedback, maxLength: textView.type.maxLength)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? DogetherTextView else { return }
        delegate?.updateFeedbackAction(feedback: textView.text)
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        if registerButton.isEnabled {
            registerButton.sendActions(for: .touchUpInside)
        }
        return true
    }
}
