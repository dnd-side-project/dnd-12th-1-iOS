//
//  AlertHelper.swift
//  dogether
//
//  Created by 박지은 on 2/18/25.
//

import UIKit
import SnapKit

class AlertHelper {
    static func alert(on viewController: UIViewController,
                      title: String,
                      message: String?,
                      okTitle: String = "확인",
                      okAction: (() -> Void)? = nil,
                      cancelTitle: String = "취소",
                      cancelAction: (() -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default, handler: { action in
            okAction?()
        })
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true)
    }
}

enum CustomAlertType {
    case logout
    case deleteAccount
}

class CustomAlertView: UIView {
    
    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    private let containerView = {
        let view = UIView()
        view.backgroundColor = .grey700
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let messageLabel = {
        let label = UILabel()
        label.textColor = .grey0
        label.textAlignment = .center
        label.font = Fonts.head2B
        label.numberOfLines = 0
        return label
    }()
    
    private let subMessageLabel = {
        let label = UILabel()
        label.textColor = .grey200
        label.textAlignment = .center
        label.font = Fonts.body1R
        label.numberOfLines = 0
        return label
    }()
    
    private let cancelButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let confirmButton: UIButton = UIButton(type: .system)
    
    init(type: CustomAlertType, confirmAction: (() -> Void)?, cancelAction: (() -> Void)?) {
        super.init(frame: .zero)
        self.confirmAction = confirmAction
        self.cancelAction = cancelAction
        setupView(type: type)
    }

    private func setupView(type: CustomAlertType) {
        addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(cancelButton)
        containerView.addSubview(confirmButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(type == .logout ? 150 : 180)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        if type == .deleteAccount {
            containerView.addSubview(subMessageLabel)
            subMessageLabel.text = "탈퇴하면 모든 데이터가 삭제되며\n복구할 수 없어요."
            subMessageLabel.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom).offset(8)
                make.left.right.equalToSuperview().inset(16)
            }
        }
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        
        switch type {
        case .logout:
            messageLabel.text = "로그아웃 하시겠어요?"
            confirmButton.setTitle("로그아웃", for: .normal)
            confirmButton.backgroundColor = .blue300
            confirmButton.setTitleColor(.grey800, for: .normal)

        case .deleteAccount:
            messageLabel.text = "정말 회원탈퇴를 하시겠어요?"
            confirmButton.setTitle("탈퇴하기", for: .normal)
            confirmButton.backgroundColor = .dogetherRed
            confirmButton.setTitleColor(.grey800, for: .normal)
        }
        confirmButton.layer.cornerRadius = 8
    }
    
    @objc private func handleCancel() {
        cancelAction?()
        removeFromSuperview()
    }
    
    @objc private func handleConfirm() {
        confirmAction?()
        removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
