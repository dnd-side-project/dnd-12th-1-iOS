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
    
    func getDestination(challengeGroupInfos: [ChallengeGroupInfo]) async throws -> BaseViewController {
        if challengeGroupInfos.isEmpty { return await StartViewController() }
        else {
            let mainViewController = await MainViewController()
            await mainViewController.viewModel.challengeGroupInfos = challengeGroupInfos
            return mainViewController
        }
    }
}
