//
//  SettingViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    private let viewModel = SettingViewModel()
    
    private let navigationHeader = NavigationHeader(title: "설정")
    
    private let logoutButton = MyPageButton(icon: nil, title: "로그아웃")
    private let withdrawButton = MyPageButton(icon: nil, title: "회원탈퇴")
    private let appVersionView: UIView = {
        let view = UIView()
        
        let titleLabel = UILabel() 
        titleLabel.text = "앱 버전"
        titleLabel.textColor = .grey100
        titleLabel.font = Fonts.body1R
        
        let versionLabel = UILabel()
        versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionLabel.textColor = .grey0
        versionLabel.font = Fonts.body1R
        
        view.addSubview(titleLabel)
        view.addSubview(versionLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        versionLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        return view
    }()

    
    private let settingStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        [logoutButton, withdrawButton, appVersionView].forEach { settingStackView.addArrangedSubview($0) }
    }
    
    override func configureAction() {
        navigationHeader.delegate = self
        
        logoutButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.showPopup(self, type: .alert, alertType: .logout) { _ in
                    self.viewModel.logout()
                    self.coordinator?.setNavigationController(OnboardingViewController())
                }
            }, for: .touchUpInside
        )
        
        withdrawButton.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                coordinator?.showPopup(self, type: .alert, alertType: .withdraw) { [weak self] _ in
                    guard let self else { return }
                    tryWithdraw()
                }
            }, for: .touchUpInside
        )
    }
    
    override func configureHierarchy() {
        [navigationHeader, settingStackView].forEach { view.addSubview($0) }
    }
    
    override func configureConstraints() {
        navigationHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        settingStackView.snp.makeConstraints {
            $0.top.equalTo(navigationHeader.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension SettingViewController {
    private func tryWithdraw() {
        Task {
            do {
                try await viewModel.withdraw()
                viewModel.logout()
                await MainActor.run {
                    coordinator?.setNavigationController(OnboardingViewController())
                }
            } catch let error as NetworkError {
                ErrorHandlingManager.presentErrorView(
                    error: error,
                    presentingViewController: self,
                    coordinator: coordinator,
                    retryHandler: { [weak self] in
                        guard let self else { return }
                        tryWithdraw()
                    }
                )
            }
        }
    }
}
