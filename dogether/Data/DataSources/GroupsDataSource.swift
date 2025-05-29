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
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        try await NetworkManager.shared.request(
            GroupsRouter.createGroup(createGroupRequest: createGroupRequest)
        )
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        try await NetworkManager.shared.request(
            GroupsRouter.joinGroup(joinGroupRequest: joinGroupRequest)
        )
    }
    
    func getIsParticipating() async throws -> GetIsParticipatingResponse {
        try await NetworkManager.shared.request(GroupsRouter.getIsParticipating)
    }
    
    func getGroups() async throws -> GetGroupsResponse {
        try await NetworkManager.shared.request(GroupsRouter.getGroups)
    }
    
    func getMyGroup() async throws -> GetMyGroupResponse {
        try await NetworkManager.shared.request(GroupsRouter.getMyGroups)
    }
    
    func saveLastSelectedGroup(saveLastSelectedGroupRequest: SaveLastSelectedGroupRequest) async throws {
        try await NetworkManager.shared.request(
            GroupsRouter.saveLastSelectedGroup(saveLastSelectedGroupRequest: saveLastSelectedGroupRequest)
        )
    }
    
    func getRanking(groupId: String) async throws -> GetRankingResponse {
        try await NetworkManager.shared.request(GroupsRouter.getRanking(groupId: groupId))
    }
}
