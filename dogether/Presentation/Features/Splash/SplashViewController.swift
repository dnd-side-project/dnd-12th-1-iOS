//
//  SplashViewController.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import RxCocoa
import RxSwift

final class SplashViewController: BaseViewController {
    private let splashPage = SplashPage()
    private let viewModel = SplashViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        pages = [splashPage]
        
        super.viewDidLoad()
        
        onAppear()
    }
    
    override func bindViewModel() {
        viewModel.needUpdate
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isNeeded in
                guard let self else { return }
                if isNeeded {
                    coordinator?.setNavigationController(UpdateViewController())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.needLogin
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isNeeded in
                guard let self else { return }
                if isNeeded {
                    coordinator?.setNavigationController(OnboardingViewController())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.needParticipating
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isNeeded in
                guard let self else { return }
                if isNeeded {
                    coordinator?.setNavigationController(StartViewController())
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SplashViewController {
    private func onAppear() {
        Task {
            do {
                try await viewModel.launchApp()
                
                try await viewModel.checkUpdate()
                if viewModel.needUpdate.value { return }
                
                try await viewModel.checkLogin()
                if viewModel.needLogin.value { return }
                
                try await viewModel.checkParticipating()
                if viewModel.needParticipating.value { return }
                
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
