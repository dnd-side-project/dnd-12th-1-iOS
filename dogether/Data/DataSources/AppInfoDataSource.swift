//
//  AppInfoDataSource.swift
//  dogether
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

final class AppInfoDataSource {
    static let shared = AppInfoDataSource()
    
    private init() { }
    
    func checkUpdate(appVersion: String) async throws -> CheckUpdateResponse {
        try await NetworkManager.shared.request(AppInfoRouter.checkUpdate(appVersion: appVersion))
    }
}
