//
//  MyPageViewModel.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyPageViewModel {
    private(set) var myProfile: MyProfileResponse?
    private let myProfileUseCase: MyProfileUseCase
    
    init() {
        let myProfileRepository = DIManager.shared.getMyProfileRepository()
        self.myProfileUseCase = MyProfileUseCase(repository: myProfileRepository)
    }
}

extension MyPageViewModel {
    func getMyProfile(getMyProfile: @escaping () -> Void) {
        Task {
            let response = try await myProfileUseCase.getMyProfile()
            self.myProfile = response
            await MainActor.run { getMyProfile() }
        }
    }
}
