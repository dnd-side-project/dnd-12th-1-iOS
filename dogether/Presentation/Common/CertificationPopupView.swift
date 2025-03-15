//
//  CertificationPopupView.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation
import UIKit
import SnapKit

protocol CertificationPopupDelegate: NSObject {
    /// CertificationTextViewText 를 전달받습니다.
    /// - Parameter text: CertificationTextViewText
    func tossCertificationTextViewText(with text: String)
    
    /// 뒤로가기 이벤트를 전달받습니다.
    func dismissAction()
}

final class CertificationPopupView: UIView {
    var cameraManager: CameraManager!
    var galleryManager: GalleryManager!
    var certificationTextView = UITextView()
    private let certificationMaxLength = 20
    
    // TODO: 추후 수정
    private var todoInfo: TodoInfo
//    private var completeAction: (String) -> Void
    
    // MARK: Delegate
    private weak var delegate: CertificationPopupDelegate?
    
    init(todoInfo: TodoInfo, delegate: any CertificationPopupDelegate) {
        self.todoInfo = todoInfo
        self.delegate = delegate
        super.init(frame: .zero)
        
        setUI()
        setupKeyboardHandling()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private var imageView = CertificationImageView(image: nil)
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "인증 하기"
        label.textColor = .grey0
        label.font = Fonts.head2B
        return label
    }()
    
    private let closeButton = {
        let button = UIButton()
        button.setImage(.close.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .grey0
        return button
    }()
    
    private let todoContentLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private func certificationButton(certificationMethod: CertificationMethods) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.grey500.cgColor
        button.layer.borderWidth = 1
        button.tag = certificationMethod.rawValue
        button.addTarget(self, action: #selector(didTapCertificationButton(_:)), for: .touchUpInside)
        
        let imageView = UIImageView(image: certificationMethod.image)
        
        let label = UILabel()
        label.text = certificationMethod.title
        label.textColor = .grey300
        label.font = Fonts.body1S
        
        [imageView, label].forEach { button.addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(30)
            $0.width.height.equalTo(20)
        }
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(imageView.snp.right).offset(8)
            $0.height.equalTo(25)
        }
        
        return button
    }
    
    private var selectButton = UIButton()
    private var shootButton = UIButton()
    
    private func certificationStackView(views: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }
    private var certificationStackView = UIStackView()
    
    private var nextButton = UIButton()
    private var certificationButton = UIButton()
    
    private let descriptionLabel = {
        let label = UILabel()
        label.text = "인증 내용을 보완해주세요!"
        label.textColor = .grey0
        label.textAlignment = .center
        label.font = Fonts.head1B
        return label
    }()
    
    private func descriptionView(tempParameter: Bool = false) -> UIView {
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
    }
    private var descriptionView = UIView()
    
    private let certificationView = {
        let view = UIView()
        view.backgroundColor = .grey800
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.blue300.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let certificationPlaceHolder = {
        let label = UILabel()
        label.textColor = .grey300
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private func certificationTextView(tempParameter: Bool = false) -> UITextView {
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
    
    private let certificationTextCountLabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .blue300
        label.font = Fonts.smallS
        return label
    }()
    
    private let certificationMaxLengthLabel = {
        let label = UILabel()
        label.textColor = .grey400
        label.font = Fonts.smallS
        return label
    }()
    
    private func setUI() {
        backgroundColor = .grey700
        layer.cornerRadius = 12
        
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        todoContentLabel.attributedText = NSAttributedString(
            string: todoInfo.content,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        selectButton = certificationButton(certificationMethod: .select)
        shootButton = certificationButton(certificationMethod: .shoot)
        certificationStackView = certificationStackView(views: [selectButton, shootButton])
        
        // NEXT BUTTON SETTING
        setNextButton()
        
        [titleLabel, closeButton, todoContentLabel, certificationStackView].forEach { addSubview($0) }
        
        self.snp.updateConstraints {
            $0.height.equalTo(240)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(28)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(24)
        }
        
        todoContentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(72)
        }
        
        certificationStackView.snp.makeConstraints {
            $0.top.equalTo(todoContentLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func didTapCloseButton() {
        delegate?.dismissAction()
    }
    
    @objc private func didTapCertificationButton(_ sender: UIButton) {
        guard let certificationMethod = CertificationMethods(rawValue: sender.tag) else { return }
        switch certificationMethod {
        case .select:
            galleryManager.openGallery()
        case .shoot:
            cameraManager.openCamera()
        }
    }
    
    func uploadImage(image: UIImage) {
        if imageView.image == nil {
            [imageView, nextButton].forEach { addSubview($0) }
            
            todoContentLabel.snp.removeConstraints()
            
            self.snp.updateConstraints {
                $0.height.equalTo(637)
            }
            
            imageView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(303)
            }
            
            todoContentLabel.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.height.equalTo(72)
            }
            
            nextButton.snp.makeConstraints {
                $0.top.equalTo(certificationStackView.snp.bottom).offset(20)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
        
        imageView.image = image
    }
    
    private func updatePopup() {
        [imageView as Any, todoContentLabel, certificationStackView, nextButton].forEach {
            let view = $0 as? UIView
            view?.isHidden = true
        }
        
        descriptionView = descriptionView()
        certificationPlaceHolder.attributedText = NSAttributedString(
            string: "팀원이 이해하기 쉽도록 인증에 대한 설명을 입력하세요.",
            attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .left)
        )
        certificationTextView = certificationTextView()
        certificationTextView.becomeFirstResponder()
        certificationMaxLengthLabel.text = "/\(certificationMaxLength)"
        
        // MARK: certificationButton SETTING
        certificationButtonSetting()
        
        [
            descriptionLabel, descriptionView,
            certificationView, certificationPlaceHolder, certificationTextView,
            certificationTextCountLabel, certificationMaxLengthLabel,
            certificationButton
        ].forEach { addSubview($0) }
        
        self.snp.updateConstraints {
            $0.height.equalTo(380)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(36)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        certificationView.snp.makeConstraints {
            $0.top.equalTo(descriptionView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(106)
        }
        
        certificationPlaceHolder.snp.makeConstraints {
            $0.top.equalTo(certificationView).offset(16)
            $0.horizontalEdges.equalTo(certificationView).inset(16)
            $0.width.equalTo(271)
        }
        
        certificationTextView.snp.makeConstraints {
            $0.top.equalTo(certificationView).offset(22)
            $0.horizontalEdges.equalTo(certificationView).inset(16)
            $0.width.equalTo(271)
            $0.height.equalTo(50)
        }
        
        certificationTextCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(certificationView).inset(16)
            $0.right.equalTo(certificationMaxLengthLabel.snp.left)
            $0.height.equalTo(18)
        }
        
        certificationMaxLengthLabel.snp.makeConstraints {
            $0.bottom.equalTo(certificationView).inset(16)
            $0.right.equalTo(certificationView).inset(16)
            $0.height.equalTo(18)
        }
        
        certificationButton.snp.makeConstraints {
            $0.top.equalTo(certificationView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
}

// MARK: SetConfigure
extension CertificationPopupView {
    
    /// 다음 버튼을 정의합니다.
    ///
    /// Objc Func 은 Objc - C 를 호출하는 코드입니다. Swift 로 해결이 충분이 가능하다면 안쓰는것도 괜찮을 것 같아요
    private func setNextButton() {
        self.nextButton = DogetherButton(title: "다음", status: .enabled)
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            updatePopup()
        }
        self.nextButton.addAction(action, for: .touchUpInside)
    }
    
    private func certificationButtonSetting() {
        
        let _certificationButton = DogetherButton(title:  "인증하기", status: .enabled)
        
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.tossCertificationTextViewText(with: certificationTextView.text)
        }
        
        _certificationButton.addAction(action, for: .touchUpInside)
        
        self.certificationButton = _certificationButton
    }
    
}

// MARK: - abount keyboard
extension CertificationPopupView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            if text.count > certificationMaxLength {
                textView.text = String(text.prefix(certificationMaxLength))
            }
            certificationPlaceHolder.isHidden = text.count > 0
            certificationTextCountLabel.text = String(textView.text.count)
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
        let keyboardHeight = keyboardFrame.height / 2.2
        let transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.transform = transform
        }
        
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.transform = .identity
        }
    }
}
