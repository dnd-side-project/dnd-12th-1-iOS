//
//  AuthRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class AuthRepositoryTest: AuthProtocol {
    func appleLogin(appleLoginRequest: AppleLoginRequest) async throws -> AppleLoginResponse {
        return AppleLoginResponse(name: "test", accessToken: "...")
    }
    
    func saveNotiToken(saveNotiTokenRequest: SaveNotiTokenRequest) async throws { }
    
    func withdraw(withdrawRequest: WithdrawRequest) async throws { }
}
