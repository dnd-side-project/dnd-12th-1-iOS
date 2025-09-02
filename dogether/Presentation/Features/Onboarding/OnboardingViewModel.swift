//
//  OnboardingViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import RxRelay

final class OnboardingViewModel {
    private let authUseCase: AuthUseCase
    private let groupUseCase: GroupUseCase
    
    private(set) var needParticipating = BehaviorRelay<Bool>(value: false)
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }

    func signInWithApple() async throws {
        authUseCase.appleLogin()
        try await authUseCase.login(domain: .apple)
    }
    
    func checkParticipating() async throws {
        needParticipating.accept(try await groupUseCase.checkParticipating())
    }
}
