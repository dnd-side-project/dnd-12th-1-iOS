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
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        
        self.appLaunchUseCase = AppLaunchUseCase()
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
    
    func launchApp() async throws {
        try await appLaunchUseCase.launchApp()
    }
    
    func getDestination() async throws -> BaseViewController {
        if UserDefaultsManager.shared.accessToken == nil { return await OnboardingViewController() }
        
        let challengeGroupInfos = try await groupUseCase.getChallengeGroupInfos()
        let destination = try await appLaunchUseCase.getDestination(challengeGroupInfos: challengeGroupInfos)
        return destination
    }
}
