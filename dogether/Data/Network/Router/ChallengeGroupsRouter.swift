//
//  ChallengeGroupsRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum ChallengeGroupsRouter: NetworkEndpoint {
    case createTodos(groupId: String, createTodosRequest: CreateTodosRequest)
    case certifyTodo(todoId: String, certifyTodoRequest: CertifyTodoRequest)
    case getMyTodos(groupId: String, date: String, status: String?)
    case getMyYesterdayTodos
    case getMemberTodos(groupId: String, memberId: String)
    case readTodo(todoId: String)
    
    var path: String {
        switch self {
        case .createTodos(let groupId, _):
            return Path.api + Path.challengeGroups + "/\(groupId)/todos"
        case .certifyTodo(let todoId, _):   // FIXME: 추후 TodosRouter 분리
            return Path.api + Path.todos + "/\(todoId)/certify"
        case .getMyTodos(let groupId, _, _):
            return Path.api + Path.challengeGroups + "/\(groupId)/my-todos"
        case .getMyYesterdayTodos:
            return Path.api + Path.challengeGroups + "/my/yesterday"
        case .getMemberTodos(let groupId, let memberId):
            return Path.api + Path.challengeGroups + "/\(groupId)/challenge-group-members/\(memberId)/today-todo-history"
        case .readTodo(let todoId): // FIXME: 추후 TodoHistoryRouter 분리
            return Path.api + Path.todoHistory + "/\(todoId)"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getMyTodos, .getMyYesterdayTodos, .getMemberTodos:
            return .get
        case .createTodos, .certifyTodo, .readTodo:
            return .post
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .getMyTodos(_, let date, let status):
            var parameters: [URLQueryItem] = [.init(name: "date", value: date)]
            if let status { parameters.append(.init(name: "status", value: status)) }
            return parameters
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
        case .createTodos(_, let createTodosRequest):
            return createTodosRequest
        case .certifyTodo(_, let certifyTodoRequest):
            return certifyTodoRequest
        default:
            return nil
        }
    }
}
