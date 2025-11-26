//
//  AuthRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum AuthRouter: NetworkEndpoint {
    case login(loginRequest: LoginRequest)
    case withdraw(withdrawRequest: WithdrawRequest)
    
    var path: String {
        switch self {
        case .login:
            return Path.api + Path.v1 + Path.auth + "/login"
        case .withdraw:
            return Path.api + Path.v1 + Path.auth + "/withdraw"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .login:
            return .post
        case .withdraw:
            return .delete
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .login:
            return [Header.Key.contentType: Header.Value.applicationJson]
        case .withdraw:
            return [
                Header.Key.contentType: Header.Value.applicationJson,
                Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .login(let loginRequest):
            return loginRequest
        case .withdraw(let withdrawRequest):
            return withdrawRequest
        }
    }
}
