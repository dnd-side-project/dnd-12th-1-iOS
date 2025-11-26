//
//  SplashViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import RxRelay

final class SplashViewModel {
    private let appLaunchUseCase: AppLaunchUseCase
    private let groupUseCase: GroupUseCase
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let appInfoRepository = DIManager.shared.getAppInfoRepository()
        
        self.appLaunchUseCase = AppLaunchUseCase(repository: appInfoRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension SplashViewModel {
    func launchApp() async throws {
        try await appLaunchUseCase.migrate()
        try await appLaunchUseCase.launchApp()
    }
    
    func checkUpdate() async throws -> Bool {
        try await appLaunchUseCase.checkUpdate()
    }
    
    func checkLogin() -> Bool {
        UserDefaultsManager.shared.accessToken == nil
    }
    
    func checkParticipating() async throws -> Bool {
        try await groupUseCase.checkParticipating()
    }
}
