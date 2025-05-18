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
    
    func getMyProfile() async throws -> MyProfileResponse {
        return try await repository.getMyProfile()
    }
}
