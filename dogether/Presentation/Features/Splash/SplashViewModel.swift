//
//  SplashViewModel.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class SplashViewModel {
    private let appLaunchUseCase: AppLaunchUseCase
    private let groupUseCase: GroupUseCase
    
    private(set) var needUpdate: Bool = false
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let appInfoRepository = DIManager.shared.getAppInfoRepository()
        
        self.appLaunchUseCase = AppLaunchUseCase(repository: appInfoRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
    
    func launchApp() async throws {
        try await appLaunchUseCase.launchApp()
    }
    
    func checkUpdate() async throws {
        needUpdate = try await appLaunchUseCase.checkUpdate()
    }
    
    func getDestination() async throws -> BaseViewController {
        if UserDefaultsManager.shared.accessToken == nil { return await OnboardingViewController() }
        
        let isParticipating = try await groupUseCase.getIsParticipating()
        let destination = try await appLaunchUseCase.getDestination(isParticipating: isParticipating)
        return destination
    }
}
