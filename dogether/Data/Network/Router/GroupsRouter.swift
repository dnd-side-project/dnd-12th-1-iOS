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
    case getGroupInfo
    case getMySummary
    case getTeamSummary
    /// 챌린지 그룹 참여 여부 확인
    case getIsJoining
    case leaveGroup
    case getGroupStatus
    
    var path: String {
        switch self {
        case .createGroup:
            return Path.api + Path.groups
        case .joinGroup:
            return Path.api + Path.groups + "/join"
        case .getGroupInfo:
            return Path.api + Path.groups + "/info/current"
        case .getMySummary:
            return Path.api + Path.groups + Path.summary + "/my"
        case .getTeamSummary:
            return Path.api + Path.groups + Path.summary + "/team"
        case .getIsJoining:
            return Path.api + Path.groups + "/isJoining"
        case .leaveGroup:
            return Path.api + Path.groups + "/leave"
        case .getGroupStatus:
            return Path.api + Path.groups + "/my" + "/status"
        }
    }
    
    var method: NetworkMethod {
        switch self {
        case .getGroupInfo, .getMySummary, .getTeamSummary, .getIsJoining, .getGroupStatus:
            return .get
        case .createGroup, .joinGroup:
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
                Header.Key.authorization: Header.Value.bearer + Header.Value.accessToken
            ]
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .createGroup(let createGroupRequest):
            return createGroupRequest
        case .joinGroup(let joinGroupRequest):
            return joinGroupRequest
        default:
            return nil
        }
    }
}
