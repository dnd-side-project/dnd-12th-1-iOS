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
    
    private(set) var needUpdate = BehaviorRelay<Bool>(value: false)
    private(set) var needLogin = BehaviorRelay<Bool>(value: false)
    private(set) var needParticipating = BehaviorRelay<Bool>(value: false)
    
    init() {
        let groupRepository = DIManager.shared.getGroupRepository()
        let appInfoRepository = DIManager.shared.getAppInfoRepository()
        
        self.appLaunchUseCase = AppLaunchUseCase(repository: appInfoRepository)
        self.groupUseCase = GroupUseCase(repository: groupRepository)
    }
}

extension SplashViewModel {
    func launchApp() async throws {
        try await appLaunchUseCase.launchApp()
    }
    
    func checkUpdate() async throws {
        needUpdate.accept(try await appLaunchUseCase.checkUpdate())
    }
    
    func checkLogin() async throws {
        needLogin.accept(UserDefaultsManager.shared.accessToken == nil)
    }
    
    func checkParticipating() async throws {
        needParticipating.accept(try await groupUseCase.checkParticipating())
    }
}
