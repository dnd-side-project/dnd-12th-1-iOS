//
//  GroupsRouter.swift
//  dogether
//
//  Created by seungyooooong on 2/6/25.
//

import Foundation

enum GroupsRouter: NetworkEndpoint {
    case createGroup(createGroupRequest: CreateGroupRequest)
    case joinGroup(joinGroupRequest: JoinGroupRequest)
    case checkParticipating
    case getGroups
    case getMySummary
    case saveLastSelectedGroup(saveLastSelectedGroupRequest: SaveLastSelectedGroupRequest)
    case getRanking(groupId: String)
    case leaveGroup(groupId: String)
    
    var path: String {
        switch self {
        case .createGroup:
            return Path.api + Path.groups
        case .joinGroup:
            return Path.api + Path.groups + "/join"
        case .checkParticipating:
            return Path.api + Path.v1 + Path.groups + "/participating"
        case .getGroups:
            return Path.api + Path.groups + "/my"
        case .getMySummary:
            return Path.api + Path.groups + Path.summary + "/my"
        case .saveLastSelectedGroup:
            return Path.api + Path.groups + "/last-selected"
        case .getRanking(let groupId):
            return Path.api + Path.groups + "/\(groupId)/ranking"
        case .leaveGroup(let groupId):
            return Path.api + Path.groups + "/\(groupId)/leave"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .checkParticipating, .getGroups, .getMySummary, .getRanking:
            return .get
        case .createGroup, .joinGroup, .saveLastSelectedGroup:
            return .post
        case .leaveGroup:
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
        default:
            return [
                Header.Key.contentType: Header.Value.applicationJson,
                Header.Key.authorization: Header.Value.bearer + (UserDefaultsManager.shared.accessToken ?? "")
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .createGroup(let createGroupRequest):
            return createGroupRequest
        case .joinGroup(let joinGroupRequest):
            return joinGroupRequest
        case .saveLastSelectedGroup(let saveLastSelectedGroupRequest):
            return saveLastSelectedGroupRequest
        default:
            return nil
        }
    }
}
