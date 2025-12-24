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
        }
    }
}
