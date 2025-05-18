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
    
    func getGroups() async throws -> GetGroupsResponse
    func getMyGroup() async throws -> GetMyGroupResponse
    func getRanking(groupId: String) async throws -> GetRankingResponse
}
