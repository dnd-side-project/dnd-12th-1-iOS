//
//  OnboardingViewController.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import UIKit

import RxSwift
import RxCocoa

final class OnboardingViewController: BaseViewController {
    private let onboardingPage = OnboardingPage()
    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        onboardingPage.delegate = self
        
        pages = [onboardingPage]
        
        super.viewDidLoad()
    }
    
    override func bindViewModel() {
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

// MARK: - delegate
protocol OnboardingDelegate {
    func signInAction()
}

extension OnboardingViewController: OnboardingDelegate {
    func signInAction() {
        Task { [weak self] in
            guard let self else { return }
            try await viewModel.signInWithApple()
            
            try await viewModel.checkParticipating()
            if viewModel.needParticipating.value { return }
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                coordinator?.setNavigationController(MainViewController())
            }
        }
    }
}
