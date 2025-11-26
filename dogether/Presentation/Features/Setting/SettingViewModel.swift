//
//  MyPageViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class SettingViewModel {
    private let authUseCase: AuthUseCase
    
    init() {
        let authRepository = DIManager.shared.getAuthRepository()
        self.authUseCase = AuthUseCase(repository: authRepository)
    }
}

extension SettingViewModel {func logout() {
        authUseCase.logout()
    }
    
    func withdraw() async throws {
        try await authUseCase.withdraw()
    }
}

