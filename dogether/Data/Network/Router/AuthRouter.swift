//
//  AuthRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum AuthRouter: NetworkEndpoint {
    case appleLogin(appleLoginRequest: AppleLoginRequest)
    case withdraw(withdrawRequest: WithdrawRequest)
    
    var path: String {
        switch self {
        case .appleLogin:
            return Path.api + Path.auth + "/login"
        case .withdraw:
            return Path.api + Path.auth + "/withdraw"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .appleLogin:
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
        case .appleLogin:
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
        case .appleLogin(let appleLoginRequest):
            return appleLoginRequest
        case .withdraw(let withdrawRequest):
            return withdrawRequest
        }
    }
}
