//
//  GroupRepository.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupRepository: GroupProtocol {
    private let groupsDataSource: GroupsDataSource
    
    init(groupsDataSource: GroupsDataSource = .shared) {
        self.groupsDataSource = groupsDataSource
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        try await groupsDataSource.createGroup(createGroupRequest: createGroupRequest)
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        try await groupsDataSource.joinGroup(joinGroupRequest: joinGroupRequest)
    }
    
    func getIsParticipating() async throws -> GetIsParticipatingResponse {
        try await groupsDataSource.getIsParticipating()
    }
    
    func getGroups() async throws -> GetGroupsResponse {
        try await groupsDataSource.getGroups()
    }
    
    func getMyGroup() async throws -> GetMyGroupResponse {
        try await groupsDataSource.getMyGroup()
    }
    
    func saveLastSelectedGroup(saveLastSelectedGroupRequest: SaveLastSelectedGroupRequest) async throws {
        try await groupsDataSource.saveLastSelectedGroup(saveLastSelectedGroupRequest: saveLastSelectedGroupRequest)
    }
    
    func getRanking(groupId: String) async throws -> GetRankingResponse {
        try await groupsDataSource.getRanking(groupId: groupId)
    }
}
