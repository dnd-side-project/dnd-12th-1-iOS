//
//  OnboardingViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class OnboardingViewModel {
    private let authUseCase: AuthUseCase
    private let groupUseCase: GroupUseCase
    private let appLaunchUseCase: AppLaunchUseCase
    
    let onboardingStep: Int = 3
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
        self.appLaunchUseCase = AppLaunchUseCase()
    }

    func signInWithApple() async throws {
        authUseCase.appleLogin()
        guard let userInfo = try await authUseCase.userInfo else { return }
        
        let appleLoginRequest = AppleLoginRequest(name: userInfo.name, idToken: userInfo.idToken)
        try await authUseCase.appleLogin(appleLoginRequest: appleLoginRequest)
    }
    
    func getDestination() async throws -> BaseViewController {
        let isParticipating = try await groupUseCase.getIsParticipating()
        let destination = try await appLaunchUseCase.getDestination(isParticipating: isParticipating)
        return destination
    }
}
