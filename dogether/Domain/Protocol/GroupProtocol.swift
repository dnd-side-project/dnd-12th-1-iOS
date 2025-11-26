//
//  GroupProtocol.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

protocol GroupProtocol {
    func createGroup(groupCreateViewDatas: GroupCreateViewDatas) async throws -> String
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse
    func leaveGroup(groupId: String) async throws
    
    func checkParticipating() async throws -> CheckParticipatingResponse
    
    // FIXME: 추후 삭제
    func getGroupsBefore() async throws -> GetGroupsResponse
    func getGroups() async throws -> GroupViewDatas
    
    func saveLastSelectedGroup(saveLastSelectedGroupRequest: SaveLastSelectedGroupRequest) async throws
    
    func getRanking(groupId: String) async throws -> GetRankingResponse
}
