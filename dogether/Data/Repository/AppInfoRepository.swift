//
//  AppInfoRepository.swift
//  dogether
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

final class AppInfoRepository: AppInfoProtocol {
    private let appInfoDataSource: AppInfoDataSource
    
    init(appInfoDataSource: AppInfoDataSource = .shared) {
        self.appInfoDataSource = appInfoDataSource
    }
    
    func checkUpdate(appVersion: String) async throws -> Bool {
        let response = try await appInfoDataSource.checkUpdate(appVersion: appVersion)
        return response.forceUpdateRequired
    }
}
