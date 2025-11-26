//
//  AuthDataSource.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class AuthDataSource {
    static let shared = AuthDataSource()
    
    private init() { }
    
    func login(loginRequest: LoginRequest) async throws -> LoginResponse {
        try await NetworkManager.shared.request(AuthRouter.login(loginRequest: loginRequest))
    }
    
    func withdraw(withdrawRequest: WithdrawRequest) async throws {
        try await NetworkManager.shared.request(AuthRouter.withdraw(withdrawRequest: withdrawRequest))
    }
}
