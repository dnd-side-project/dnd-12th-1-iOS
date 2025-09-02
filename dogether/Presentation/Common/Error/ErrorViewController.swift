//
//  ErrorViewController.swift
//  dogether
//
//  Created by yujaehong on 7/8/25.
//

import UIKit
import SnapKit


final class ErrorViewController: BaseViewController {

    // MARK: - Config
    private let config: ErrorTemplateConfig
    private let showCloseButton: Bool

    // MARK: - UI Components
    private let errorView: ErrorView
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .grey0
        return button
    }()

    // MARK: - Actions
    var leftButtonAction: (() -> Void)?
    var rightButtonAction: (() -> Void)?

    init(config: ErrorTemplateConfig, showCloseButton: Bool = true) {
        self.config = config
        self.showCloseButton = showCloseButton
        self.errorView = ErrorView(config: config)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configureView() {
        view.backgroundColor = .clear
    }

    override func configureHierarchy() {
        view.addSubview(errorView)
        view.addSubview(closeButton)
    }

    override func configureConstraints() {
        errorView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(56)
            $0.left.right.bottom.equalToSuperview()
        }
        
        if showCloseButton {
            closeButton.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
                $0.trailing.equalToSuperview().inset(16)
                $0.size.equalTo(24)
            }
        }
    }
    
    override func configureAction() {
        if showCloseButton {
            closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        }
        
        errorView.leftButtonAction = { [weak self] in
            guard let self else { return }
            dismiss(animated: false) { [weak self] in
                guard let self else { return }
                leftButtonAction?()
            }
        }
        
        errorView.rightButtonAction = { [weak self] in
            guard let self else { return }
            dismiss(animated: false) { [weak self] in
                guard let self else { return }
                rightButtonAction?()
            }
        }
    }
    
    @objc private func didTapClose() {
        dismiss(animated: false)
    }
}
