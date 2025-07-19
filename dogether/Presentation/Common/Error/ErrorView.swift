//
//  ErrorView.swift
//  dogether
//
//  Created by yujaehong on 7/8/25.
//

import UIKit

final class ErrorView: BaseView {

    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?

    private let config: ErrorTemplateConfig

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.head2B
        label.textColor = .grey200
        label.textAlignment = .center
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.body2R
        label.textColor = .grey400
        label.textAlignment = .center
        return label
    }()

    private let leftButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.body1S
        button.setTitleColor(.grey300, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grey500.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let rightButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.body1B
        button.setTitleColor(.grey800, for: .normal)
        button.backgroundColor = .blue300
        button.layer.cornerRadius = 8
        return button
    }()

    private let singleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Fonts.body1B
        button.setTitleColor(.grey800, for: .normal)
        button.backgroundColor = .blue300
        button.layer.cornerRadius = 8
        return button
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 11
        stack.distribution = .fillEqually
        return stack
    }()

    init(config: ErrorTemplateConfig) {
        self.config = config
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureView() {
        backgroundColor = .clear

        imageView.image = config.image
        titleLabel.text = config.title
        subTitleLabel.text = config.subtitle

        if let rightTitle = config.rightButtonTitle {
            leftButton.setTitle(config.leftButtonTitle, for: .normal)
            rightButton.setTitle(rightTitle, for: .normal)
        } else {
            singleButton.setTitle(config.leftButtonTitle, for: .normal)
        }
    }

    override func configureHierarchy() {
        addSubview(imageView)
        addSubview(titleLabel)

        if let subtitle = config.subtitle, !subtitle.isEmpty {
            addSubview(subTitleLabel)
        }

        if config.rightButtonTitle != nil {
            buttonStackView.addArrangedSubview(leftButton)
            buttonStackView.addArrangedSubview(rightButton)
            addSubview(buttonStackView)
        } else {
            addSubview(singleButton)
        }
    }

    override func configureConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(141)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        if subTitleLabel.superview != nil {
            subTitleLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(5)
                $0.centerX.equalToSuperview()
            }
        }

        if buttonStackView.superview != nil {
            buttonStackView.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.superview != nil ? subTitleLabel.snp.bottom : titleLabel.snp.bottom).offset(20)
                $0.leading.trailing.equalToSuperview().inset(36)
                $0.height.equalTo(50)
            }
        } else {
            singleButton.snp.makeConstraints {
                $0.top.equalTo(subTitleLabel.superview != nil ? subTitleLabel.snp.bottom : titleLabel.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
                $0.height.equalTo(50)
                $0.width.equalTo(160)
            }
        }
    }

    override func configureAction() {
        leftButton.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
        singleButton.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
    }

    @objc private func didTapLeft() {
        leftButtonAction?()
    }

    @objc private func didTapRight() {
        rightButtonAction?()
    }
}
