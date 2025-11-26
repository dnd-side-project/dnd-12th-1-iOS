//
//  SettingViewController.swift
//  dogether
//
//  Created by yujaehong on 4/21/25.
//

import Foundation

final class SettingViewController: BaseViewController {
    private let settingPage = SettingPage()
    private let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        settingPage.delegate = self
        
        pages = [settingPage]
        
        super.viewDidLoad()
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


// MARK: - delegate
protocol SettingDelegate {
    func logoutAction()
    func withdrawAction()
}

extension SettingViewController: SettingDelegate {
    func logoutAction() {
        coordinator?.showPopup(self, type: .alert, alertType: .logout) { _ in
            self.viewModel.logout()
            self.coordinator?.setNavigationController(OnboardingViewController())
        }
    }
    
    func withdrawAction() {
        coordinator?.showPopup(self, type: .alert, alertType: .withdraw) { [weak self] _ in
            guard let self else { return }
            tryWithdraw()
        }
    }
}
