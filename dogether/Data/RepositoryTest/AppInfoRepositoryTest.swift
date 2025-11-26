//
//  AppInfoRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

final class AppInfoRepositoryTest: AppInfoProtocol {
    func checkUpdate(appVersion: String) async throws -> Bool {
        return false
    }
}
