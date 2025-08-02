//
//  MyProfileUseCase.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyProfileUseCase {
    private let repository: MyProfileProtocol
    
    init(repository: MyProfileProtocol) {
        self.repository = repository
    }
    
    func getProfileInfo() async throws -> ProfileInfo {
        let response = try await repository.getMyProfile()
        return ProfileInfo(name: response.name, imageUrl: response.profileImageUrl)
    }
}
