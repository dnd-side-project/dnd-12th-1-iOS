//
//  GroupsDataSource.swift
//  dogether
//
//  Created by seungyooooong on 3/1/25.
//

import Foundation

final class GroupsDataSource {
    static let shared = GroupsDataSource()
    
    private init() { }
    
    func getIsJoining() async throws -> GetIsJoiningResponse {
        try await NetworkManager.shared.request(GroupsRouter.getIsJoining)
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        try await NetworkManager.shared.request(
            GroupsRouter.createGroup(createGroupRequest: createGroupRequest)
        )
    }
    
    func getGroupStatus() async throws -> GetGroupStatusResponse {
        try await NetworkManager.shared.request(GroupsRouter.getGroupStatus)
    }
    
    func getGroupInfo() async throws -> GetGroupInfoResponse {
        try await NetworkManager.shared.request(GroupsRouter.getGroupInfo)
    }
    
    func getTeamSummary() async throws -> GetTeamSummaryResponse {
        try await NetworkManager.shared.request(GroupsRouter.getTeamSummary)
    }
}
