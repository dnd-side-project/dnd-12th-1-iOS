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

enum StatusType: String {
    case approve = "APPROVE"
    case reject = "REJECT"
}

enum CertificationListRouter: NetworkEndpoint {
    case getMyActivity(sort: SortType, status: StatusType)

    var path: String {
        return Path.api + Path.myActivity
    }

    var method: NetworkMethod {
        return .get
    }

    var parameters: [URLQueryItem]? {
        switch self {
        case .getMyActivity(let sort, let status):
            return [
                URLQueryItem(name: "sort", value: sort.rawValue),
                URLQueryItem(name: "status", value: status.rawValue)
            ]
        }
    }

    var header: [String: String]? {
        return [
            Header.Key.contentType: Header.Value.applicationJson,
            Header.Key.authorization: Header.Value.bearer + Header.Value.accessToken
        ]
    }

    var body: Encodable? {
        return nil
    }
}
