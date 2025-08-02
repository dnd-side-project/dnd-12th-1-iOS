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
    
    func appleLogin(appleLoginRequest: AppleLoginRequest) async throws -> AppleLoginResponse {
        try await NetworkManager.shared.request(AuthRouter.appleLogin(appleLoginRequest: appleLoginRequest))
    }
    
    func withdraw(withdrawRequest: WithdrawRequest) async throws {
        try await NetworkManager.shared.request(AuthRouter.withdraw(withdrawRequest: withdrawRequest))
    }
}
