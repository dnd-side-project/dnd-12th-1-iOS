//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

final class SplashViewController: BaseViewController {
    private let splashPage = SplashPage()
    private let viewModel = SplashViewModel()
    
    override func viewDidLoad() {
        pages = [splashPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
}

extension SplashViewController {
    private func onAppear() {
        Task {
            // MARK: SplashView의 경우 API 호출에 순서가 정해져있어 동기 호출 방식 보다는 로딩바를 임시로 하나 더 추가해 제어함
            LoadingManager.shared.showLoading()
            defer { LoadingManager.shared.hideLoading() }
            
            do {
                try await viewModel.launchApp()
                
                if try await viewModel.checkUpdate() {
                    coordinator?.setNavigationController(UpdateViewController())
                    return
                }
                
                if viewModel.checkLogin() {
                    coordinator?.setNavigationController(OnboardingViewController())
                    return
                }
                
                if try await viewModel.checkParticipating() {
                    coordinator?.setNavigationController(StartViewController())
                    return
                }
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    coordinator?.setNavigationController(MainViewController())
                }
            } catch {
                await MainActor.run {
                    ErrorHandlingManager.presentErrorView(
                        error: error,
                        presentingViewController: self,
                        coordinator: coordinator,
                        retryHandler: { [weak self] in
                            guard let self else { return }
                            onAppear()
                        },
                        showCloseButton: false
                    )
                }
            }
        }
    }
}
