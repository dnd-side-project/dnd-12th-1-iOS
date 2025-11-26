//
//  AuthRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class AuthRepository: AuthProtocol {
    private let authDataSource: AuthDataSource
    private let notificationDataSource: NotificationDataSource
    
    init(
        authDataSource: AuthDataSource = .shared,
        notificationDataSou: NotificationDataSource = .shared
    ) {
        self.authDataSource = authDataSource
        self.notificationDataSource = notificationDataSou
    }
    
    func login(
        loginType: LoginTypes,
        providerId: String,
        name: String?
    ) async throws -> (userFullName: String, accessToken: String) {
        let request = LoginRequest(loginType: loginType.rawValue, providerId: providerId, name: name)
        let response = try await authDataSource.login(loginRequest: request)
        return (response.name, response.accessToken)
    }
    
    func saveNotiToken(saveNotiTokenRequest: SaveNotiTokenRequest) async throws {
        try await notificationDataSource.saveNotiToken(saveNotiTokenRequest: saveNotiTokenRequest)
    }
    
    func withdraw(loginType: LoginTypes, authorizationCode: String?) async throws {
        let request = WithdrawRequest(loginType: loginType.rawValue, authorizationCode: authorizationCode)
        try await authDataSource.withdraw(withdrawRequest: request)
    }
}

