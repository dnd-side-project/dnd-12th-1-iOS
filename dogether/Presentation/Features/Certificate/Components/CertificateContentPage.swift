//
//  CertificateContentPage.swift
//  dogether
//
//  Created by seungyooooong on 12/9/25.
//

import UIKit

final class CertificateContentPage: BasePage {
    var delegate: CertificateContentDelegate? {
        didSet {
            certificateButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.certifyTodoAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "인증 하기")
    private let descriptionLabel = UILabel()
    private let descriptionView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.grey600.cgColor
        view.layer.borderWidth = 1
        
        let imageView = UIImageView(image: .notice)
        
        let label = UILabel()
        label.text = "한번 인증한 내용은 바꿀 수 없어요"
        label.textColor = .grey200
        label.font = Fonts.body2S
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        [stackView].forEach { view.addSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        
        return view
    }()
    private let certificationTextView = DogetherTextView(type: .certification)
    private let certificateButton = DogetherButton("인증하기")
    
    private(set) var currentIsFirstResponder: Bool?
    private(set) var currentKeyboardHeight: CGFloat?
    private(set) var isFirst: Bool = true
    
    override func configureView() {
        descriptionLabel.text = "인증 내용을 보완해주세요!"
        descriptionLabel.textColor = .grey0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = Fonts.head1B
    }
    
    override func configureAction() {
        addTapAction { [weak self] _ in
            guard let self else { return }
            endEditing(true)
        }
        
        navigationHeader.delegate = coordinatorDelegate
        
        certificationTextView.delegate = self
        observeKeyboardNotifications()
    }
    
    override func configureHierarchy() {
        [ navigationHeader,
          descriptionLabel, descriptionView, certificationTextView,
          certificateButton
        ].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(navigationHeader.snp.bottom).offset(40)
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            $0.height.equalTo(25)
        }
        
        certificationTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(48)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(106)
        }
        
        certificateButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - updateView
    override func updateView(_ data: (any BaseEntity)?) {
        if let datas = data as? CertificateViewDatas {
            if currentIsFirstResponder != datas.isFirstResponder {
                currentIsFirstResponder = datas.isFirstResponder
                
                if datas.isFirstResponder { certificationTextView.becomeFirstResponder() }
            }
            
            // MARK: subTitleLabel 등 일반 UI의 구성을 최초 진행, 이후 joinButton 애니메이션을 위해 위치 조정
            if isFirst {
                isFirst = false
                
                layoutIfNeeded()
            }
            
            if currentKeyboardHeight != datas.keyboardHeight {
                currentKeyboardHeight = datas.keyboardHeight
                
                certificateButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(datas.keyboardHeight + 16)
                }
                UIView.animate(withDuration: 0.35) { [weak self] in
                    guard let self else { return }
                    layoutIfNeeded()
                }
            }
        }
        
        if let datas = data as? DogetherTextViewDatas {
            certificationTextView.updateView(datas)
        }
        
        if let datas = data as? DogetherButtonViewDatas {
            certificateButton.updateView(datas)
        }
    }
}

// MARK: - Keyboard
extension CertificateContentPage {
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
        delegate?.updateKeyboardHeightAction(height: frame.height - UIApplication.safeAreaOffset.bottom)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        delegate?.updateKeyboardHeightAction(height: 0)
    }
}

// MARK: - UITextFieldDelegate
extension CertificateContentPage: UITextViewDelegate {
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
        
//        let content = String((textView.text ?? "").prefix(textView.type.maxLength))
//        textView.text = content
//        delegate?.updateContentAction(content: content)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? DogetherTextView else { return }
        delegate?.updateContentAction(content: textView.text)
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        if certificateButton.isEnabled {
            certificateButton.sendActions(for: .touchUpInside)
        }
        return true
    }
}
