//
//  GroupProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

protocol GroupProtocol {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse
    func leaveGroup(groupId: String) async throws
    
    func getIsParticipating() async throws -> GetIsParticipatingResponse
    
    func getGroups() async throws -> GetGroupsResponse
    
    func saveLastSelectedGroup(saveLastSelectedGroupRequest: SaveLastSelectedGroupRequest) async throws
    
    func getRanking(groupId: String) async throws -> GetRankingResponse
}
