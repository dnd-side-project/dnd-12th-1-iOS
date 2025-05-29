//
//  StatsRouter.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

enum StatsRouter: NetworkEndpoint {
    case fetchGroupStats(groupId: Int)
    
    var path: String {
        switch self {
        case .fetchGroupStats(let groupId):
            return Path.api + "/my" + Path.groups + "/\(groupId)/activity"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .fetchGroupStats:
            return .get
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
        default:
            return [
                Header.Key.contentType: Header.Value.applicationJson,
                Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
            ]
        }
    }
    
    var body: Encodable? {
        return nil
    }
}
