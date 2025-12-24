//
//  UserDataSource.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class UserDataSource {
    static let shared = UserDataSource()
    
    private init() {}
    
    func getMyGroupActivity(groupId: Int) async throws -> GetMyGroupActivityResponse {
        try await NetworkManager.shared.request(UserRouter.getMyGroupActivity(groupId: groupId))
    }
    
    func getMyActivity(sort: String, page: String) async throws -> GetMyActivityResponse {
        try await NetworkManager.shared.request(UserRouter.getMyActivity(sort: sort, page: page))
    }
    
    func getMyProfile() async throws -> GetMyProfileResponse {
        try await NetworkManager.shared.request(UserRouter.getMyProfile)
    }
}
