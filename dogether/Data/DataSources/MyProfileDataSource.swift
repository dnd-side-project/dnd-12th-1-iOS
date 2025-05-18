//
//  MyProfileDataSource.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

final class MyProfileDataSource {
    static let shared = MyProfileDataSource()
    
    private init() {}
    
    func getMyProfile() async throws -> MyProfileResponse {
        try await NetworkManager.shared.request(MyProfileRouter.getMyProfile)
    }
}
