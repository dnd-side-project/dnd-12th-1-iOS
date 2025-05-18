//
//  MyProfileRepository.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyProfileRepository: MyProfileProtocol {
    private let dataSource: MyProfileDataSource
    
    init(dataSource: MyProfileDataSource = .shared) {
        self.dataSource = dataSource
    }
    
    func getMyProfile() async throws -> MyProfileResponse {
        try await dataSource.getMyProfile()
    }
}
