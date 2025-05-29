//
//  NotificationsRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum NotificationsRouter: NetworkEndpoint {
    case saveNotiToken(saveNotiTokenRequest: SaveNotiTokenRequest)
    case removeNotiToken(removeNotiTokenRequest: RemoveNotiTokenRequest)
    
    var path: String {
        switch self {
        case .saveNotiToken:
            return Path.api + Path.notification + Path.tokens
        case .removeNotiToken:
            return Path.api + Path.notification + Path.tokens
        }
    }
    
    // MARK: - method
    var method: NetworkMethod {
        switch self {
        case .saveNotiToken:
            return .post
        case .removeNotiToken:
            return .delete
        }
    }
    
    // MARK: - parameters
    var parameters: [URLQueryItem]? {
        switch self {
        default:
            return nil
        }
    }
    
    // MARK: - header
    var header: [String : String]? {
        switch self {
        default:
            return [
                Header.Key.contentType: Header.Value.applicationJson,
                Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
            ]
        }
    }
    
    // MARK: - body
    var body: (any Encodable)? {
        switch self {
        case .saveNotiToken(let saveNotiTokenRequest):
            return saveNotiTokenRequest
        case .removeNotiToken(let removeNotiTokenRequest):
            return removeNotiTokenRequest
        }
    }
}
