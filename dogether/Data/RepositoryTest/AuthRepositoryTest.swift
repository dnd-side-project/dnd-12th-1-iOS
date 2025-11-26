//
//  AuthRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class AuthRepositoryTest: AuthProtocol {
    func login(
        loginType: LoginTypes,
        providerId: String,
        name: String?
    ) async throws -> (userFullName: String, accessToken: String) {
        (userFullName: "test", accessToken: "...")
    }
    
    func saveNotiToken(saveNotiTokenRequest: SaveNotiTokenRequest) async throws { }
    
    func withdraw(loginType: LoginTypes, authorizationCode: String?) async throws { }
}
