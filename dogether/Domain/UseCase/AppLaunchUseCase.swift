//
//  AppLaunchUseCase.swift
//  dogether
//
//  Created by seungyooooong on 5/7/25.
//

import Foundation

final class AppLaunchUseCase {
    private let repository: AppInfoProtocol
    
    init(repository: AppInfoProtocol) {
        self.repository = repository
    }
    
    func launchApp() async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func checkUpdate() async throws -> Bool {
        let response = try await repository.checkUpdate(appVersion: SystemManager.appVersion ?? "1.0.0")
        return response.forceUpdateRequired
    }
}
