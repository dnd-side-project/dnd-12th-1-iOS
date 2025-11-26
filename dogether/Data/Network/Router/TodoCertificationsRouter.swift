//
//  TodoCertificationsRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum TodoCertificationsRouter: NetworkEndpoint {
    case reviewTodo(todoId: String, reviewTodoRequest: ReviewTodoRequest)
    case getReviews
    
    var path: String {
        switch self {
        case .reviewTodo(let todoId, _):
            return Path.api + Path.v1 + Path.todoCertifications + "/\(todoId)/review"
        case .getReviews:
            return Path.api + Path.v1 + Path.todoCertifications + "/pending-review"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getReviews:
            return .get
        case .reviewTodo:
            return .post
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
    
    var body: (any Encodable)? {
        switch self {
        case .reviewTodo(_, let reviewTodoRequest):
            return reviewTodoRequest
        default:
            return nil
        }
    }
}
