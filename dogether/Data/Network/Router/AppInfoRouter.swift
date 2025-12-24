//
//  AppInfoRouter.swift
//  dogether
//
//  Created by seungyooooong on 7/1/25.
//

import Foundation

enum AppInfoRouter: NetworkEndpoint {
    case checkUpdate(appVersion: String)
    
    var path: String {
        switch self {
        case .checkUpdate:
            return Path.api + Path.v1 + Path.appInfo + "/force-update-check"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .checkUpdate:
            return .get
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .checkUpdate(let version):
            return [.init(name: "app-version", value: version)]
        }
    }
    
    var header: [String : String]? {
        switch self {
        case .checkUpdate:
            return [Header.Key.contentType: Header.Value.applicationJson]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        default:
            return nil
        }
    }
}
