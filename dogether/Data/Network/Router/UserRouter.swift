//
//  UserRouter.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

enum UserRouter: NetworkEndpoint {
    case getMyGroupActivity(groupId: Int)
    case getMyActivity(sort: String, page: String)
    case getMyProfile

    var path: String {
        switch self {
        case .getMyGroupActivity(let groupId):
            return Path.api + Path.v1 + Path.my + Path.groups + "/\(groupId)/activity"
        case .getMyActivity:
            return Path.api + Path.v1 + Path.my + "/activity"
        case .getMyProfile:
            return Path.api + Path.v1 + Path.my + "/profile"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getMyGroupActivity, .getMyActivity, .getMyProfile:
            return .get
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case let .getMyActivity(sort, page):
            return [
                .init(name: "sortBy", value: sort),
                .init(name: "page", value: page)
            ]
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
