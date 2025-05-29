//
//  CertificationListRouter.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

enum SortType: String {
    case todoCompletedAt = "TODO_COMPLETED_AT"
    case groupCreatedAt = "GROUP_CREATED_AT"
}

enum CertificationListRouter: NetworkEndpoint {
    case getMyActivity(sort: SortType)

    var path: String {
        return Path.api + Path.myActivity
    }

    var method: NetworkMethod {
        return .get
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case .getMyActivity(let sort):
            return [
                URLQueryItem(name: "sort", value: sort.rawValue)
            ]
        }
    }

    var header: [String: String]? {
        return [
            Header.Key.contentType: Header.Value.applicationJson,
            Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
        ]
    }

    var body: Encodable? {
        return nil
    }
}
