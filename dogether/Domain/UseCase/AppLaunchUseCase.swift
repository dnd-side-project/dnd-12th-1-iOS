//
//  AppLaunchUseCase.swift
//  dogether
//
//  Created by seungyooooong on 5/7/25.
//

import Foundation

final class AppLaunchUseCase {
    func launchApp() async throws {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
    }
    
    func getDestination(isParticipating: Bool) async throws -> BaseViewController {
        if isParticipating { return await MainViewController() }
        else { return await StartViewController() }
    }
}
