//
//  AuthProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

protocol AuthProtocol {
    func appleLogin(appleLoginRequest: AppleLoginRequest) async throws -> AppleLoginResponse
    func saveNotiToken(saveNotiTokenRequest: SaveNotiTokenRequest) async throws
    func withdraw(withdrawRequest: WithdrawRequest) async throws
}

