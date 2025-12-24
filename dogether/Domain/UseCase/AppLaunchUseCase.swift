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
    
    func migrate() async throws {
        let lastAccessVersion = UserDefaultsManager.shared.lastAccessVersion
        UserDefaultsManager.shared.lastAccessVersion = SystemManager.appVersion
        
        if isVersionAtMost("1.0.5", comparedTo: lastAccessVersion) {
            UserDefaultsManager.shared.loginType = LoginTypes.apple.rawValue
        }
    }

    func launchApp() async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    func checkUpdate() async throws -> Bool {
        try await repository.checkUpdate(appVersion: SystemManager.appVersion ?? "1.0.0")
    }
}

extension AppLaunchUseCase {
    func isVersionAtMost(_ baseVersion: String, comparedTo comparisonVersion: String?) -> Bool {
        guard let comparisonVersion = comparisonVersion else { return true }
        
        let baseComponents = baseVersion.split(separator: ".").compactMap { Int($0) }
        let comparisonComponents = comparisonVersion.split(separator: ".").compactMap { Int($0) }

        let maxLength = max(baseComponents.count, comparisonComponents.count)

        for i in 0 ..< maxLength {
            let base = i < baseComponents.count ? baseComponents[i] : 0
            let comparison = i < comparisonComponents.count ? comparisonComponents[i] : 0

            if comparison > base {
                return false
            } else if comparison < base {
                return true
            }
        }

        return true
    }
}
