//
//  AlertPopupView.swift
//  dogether
//
//  Created by seungyooooong on 4/1/25.
//

import UIKit

final class AlertPopupView: BasePopupView {
    private let type: AlertTypes
    
    init(type: AlertTypes) {
        self.type = type
        super.init(frame: .zero)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.numberOfLines = 0
        return label
    }()
    
    private let messageLabel = {
        let label = UILabel()
        label.textColor = .grey200
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - PopupViewController에서 action handling
    let confirmButton = {
        let button = UIButton()
        button.setTitleColor(.grey800, for: .normal)
        button.titleLabel?.font = Fonts.body1S
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let cancelButton = {
        let button = UIButton()
        button.setTitleColor(.grey300, for: .normal)
        button.titleLabel?.font = Fonts.body1S
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grey500.cgColor
        return button
    }()
    
    private let buttonStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 11
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let contentStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override func configureView() {
        imageView.image = type.image
        
        titleLabel.attributedText = NSAttributedString(
            string: type.title,
            attributes: Fonts.getAttributes(for: Fonts.head1B, textAlignment: .center)
        )
        
        if let message = type.message {
            messageLabel.attributedText = NSAttributedString(
                string: message,
                attributes: Fonts.getAttributes(for: Fonts.body1R, textAlignment: .center)
            )
        }
        
        cancelButton.setTitle(type.cancelText, for: .normal)
        
        confirmButton.setTitle(type.buttonText, for: .normal)
        confirmButton.backgroundColor = type.buttonColor
        
        [cancelButton, confirmButton].forEach { buttonStackView.addArrangedSubview($0) }
        
        [titleLabel, messageLabel, buttonStackView].forEach { contentStackView.addArrangedSubview($0) }
        contentStackView.setCustomSpacing(8, after: titleLabel)
        contentStackView.setCustomSpacing(20, after: messageLabel)
    }
    
    override func configureAction() {
        cancelButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                delegate?.hidePopup()
            }, for: .touchUpInside
        )
    }
    override func configureHierarchy() {
        [imageView, contentStackView].forEach { addSubview($0) }
    }

    override func configureConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(48)
        }
 
        if imageView.image == nil {
            contentStackView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(32)
                $0.bottom.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        } else {
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(32)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(48)
            }
            contentStackView.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(12)
                $0.bottom.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview().inset(20)
            }
        }
    }
}
