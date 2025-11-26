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
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.authUseCase = AuthUseCase(repository: authRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }

    func login(loginType: LoginTypes) async throws {
        try await authUseCase.login(loginType: loginType)
    }
    
    func checkParticipating() async throws -> Bool {
        try await groupUseCase.checkParticipating()
    }
}
