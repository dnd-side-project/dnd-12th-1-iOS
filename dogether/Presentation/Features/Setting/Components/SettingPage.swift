//
//  SettingPage.swift
//  dogether
//
//  Created by seungyooooong on 11/23/25.
//

import UIKit
import SnapKit

final class SettingPage: BasePage {
    var delegate: SettingDelegate? {
        didSet {
            logoutButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.logoutAction()
                }, for: .touchUpInside
            )
            
            withdrawButton.addAction(
                UIAction { [weak self] _ in
                    guard let self else { return }
                    delegate?.withdrawAction()
                }, for: .touchUpInside
            )
        }
    }
    
    private let navigationHeader = NavigationHeader(title: "설정")
    private let logoutButton = SettingButton(title: "로그아웃")
    private let withdrawButton = SettingButton(title: "회원탈퇴")
    private let testButton = SettingButton(title: "앱 버전", text: SystemManager.appVersion)
    private let settingStackView = UIStackView()
    
    
    override func configureView() {
        settingStackView.axis = .vertical
    }
    
    override func configureAction() {
        navigationHeader.delegate = coordinatorDelegate
    }
    
    override func configureHierarchy() {
        [logoutButton, withdrawButton, testButton].forEach { settingStackView.addArrangedSubview($0) }
        
        [navigationHeader, settingStackView].forEach { addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        settingStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}
