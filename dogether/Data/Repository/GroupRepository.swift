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
    
    func createGroup(groupCreateViewDatas: GroupCreateViewDatas) async throws -> String {
        let request = CreateGroupRequest(
            groupName: groupCreateViewDatas.groupName,
            maximumMemberCount: groupCreateViewDatas.memberCount,
            startAt: groupCreateViewDatas.startAt.rawValue,
            duration: groupCreateViewDatas.duration.rawValue
        )
        let response = try await groupsDataSource.createGroup(createGroupRequest: request)
        return response.joinCode
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        try await groupsDataSource.joinGroup(joinGroupRequest: joinGroupRequest)
    }
    
    func leaveGroup(groupId: String) async throws {
        try await groupsDataSource.leaveGroup(groupId: groupId)
    }
    
    func checkParticipating() async throws -> CheckParticipatingResponse {
        try await groupsDataSource.checkParticipating()
    }
    
    func getGroupsBefore() async throws -> GetGroupsResponse {
        try await groupsDataSource.getGroups()
    }
    
    func getGroups() async throws -> GroupViewDatas {
        let response = try await groupsDataSource.getGroups()
        return GroupViewDatas(
            index: response.lastSelectedGroupIndex ?? 0,
            groups: response.joiningChallengeGroups.map {
                GroupEntity(
                    id: $0.groupId,
                    name: $0.groupName,
                    currentMember: $0.currentMemberCount,
                    maximumMember: $0.maximumMemberCount,
                    joinCode: $0.joinCode,
                    status: MainViewStatus(rawValue: $0.status) ?? .running,
                    startDate: $0.startAt,
                    endDate: $0.endAt,
                    duration: $0.progressDay,
                    progress: $0.progressRate
                )
            }
        )
    }
    
    func saveLastSelectedGroup(saveLastSelectedGroupRequest: SaveLastSelectedGroupRequest) async throws {
        try await groupsDataSource.saveLastSelectedGroup(saveLastSelectedGroupRequest: saveLastSelectedGroupRequest)
    }
    
    func getRanking(groupId: String) async throws -> GetRankingResponse {
        try await groupsDataSource.getRanking(groupId: groupId)
    }
}
