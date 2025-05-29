//
//  MyProfileRouter.swift
//  dogether
//
//  Created by yujaehong on 5/17/25.
//

import Foundation

enum MyProfileRouter: NetworkEndpoint {
    case getMyProfile
    
    var path: String {
        switch self {
        case .getMyProfile:
            return Path.api + Path.myProfile
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getMyProfile:
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
