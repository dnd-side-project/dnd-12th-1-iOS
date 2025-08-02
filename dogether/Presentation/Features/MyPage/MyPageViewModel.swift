//
//  MyPageViewModel.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyPageViewModel {
    private(set) var profile: ProfileInfo = ProfileInfo()
    private let myProfileUseCase: MyProfileUseCase
    
    init() {
        let myProfileRepository = DIManager.shared.getMyProfileRepository()
        self.myProfileUseCase = MyProfileUseCase(repository: myProfileRepository)
    }
}

extension MyPageViewModel {
    func getProfileInfo() async throws {
        self.profile = try await myProfileUseCase.getProfileInfo()
    }
}
