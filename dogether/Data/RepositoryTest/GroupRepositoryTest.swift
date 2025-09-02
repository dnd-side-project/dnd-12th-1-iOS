//
//  GroupRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class GroupRepositoryTest: GroupProtocol {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        if createGroupRequest.groupName == "1" {
            throw NetworkError.badRequest
        }
        
        if createGroupRequest.groupName == "2" {
            throw NetworkError.noData
        }
        
        if createGroupRequest.groupName == "3" {
            throw NetworkError.serverError(message: "서버 에러가 발생했습니다.")
        }
            
        return CreateGroupResponse(joinCode: "000000")
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        let code = joinGroupRequest.joinCode
        
        if code == "00000000" {
            throw NetworkError.dogetherError(code: .CGF0005, message: "유효하지 않은 그룹입니다.")
        }
        
        if code == "11111111" {
            throw NetworkError.dogetherError(code: .CGF0002, message: "이미 참여한 그룹입니다.")
        }
        
        if code == "22222222" {
            throw NetworkError.dogetherError(code: .CGF0004, message: "종료된 그룹입니다.")
        }
        
        if code == "33333333" {
            throw NetworkError.dogetherError(code: .CGF0003, message: "그룹 인원이 가득 찼습니다.")
        }
        
        if code == "44444444" {
            throw NetworkError.serverError(message: "서버에러")
        }
        
        if code == "55555555" {
            throw NetworkError.decodingFailed
        }
        
        if code == "66666666" {
            throw NetworkError.noData
        }
        
        return JoinGroupResponse(groupName: "testGroup", duration: 3, maximumMemberCount: 10, startAt: "2025-01-01", endAt: "2025-01-04")
    }
    
    func leaveGroup(groupId: String) { }
    
    func checkParticipating() async throws -> CheckParticipatingResponse {
        return CheckParticipatingResponse(checkParticipating: true)
    }
    
    func getGroups() async throws -> GetGroupsResponse {
        return GetGroupsResponse(
            lastSelectedGroupIndex: 0,
            joiningChallengeGroups: [
                JoiningChallengeGroups(
                    groupId: 0,
                    groupName: "폰트의 챌린지",
                    currentMemberCount: 1,
                    maximumMemberCount: 10,
                    joinCode: "G3hIj4kLm",
                    status: "RUNNING",
                    startAt: "25.05.01",
                    endAt: "25.05.04",
                    progressDay: 5,
                    progressRate: 0.3
                ), JoiningChallengeGroups(
                    groupId: 22,
                    groupName: "폰트의 챌린지222",
                    currentMemberCount: 2,
                    maximumMemberCount: 10,
                    joinCode: "G3hIj4222",
                    status: "READY",
                    startAt: "25.05.01",
                    endAt: "25.05.04",
                    progressDay: 1,
                    progressRate: 0.3
                )
            ]
        )
    }
    
    func saveLastSelectedGroup(saveLastSelectedGroupRequest: SaveLastSelectedGroupRequest) async throws { }
    
    func getRanking(groupId: String) async throws -> GetRankingResponse {
        let rankings = (1 ... 20).map {
            RankingResponse(
                memberId: $0,
                rank: $0,
                profileImageUrl: "",
                name: "testName \($0)",
                historyReadStatus: $0 % 3 == 0 ? "NULL" : $0 % 3 == 1 ? "READ_YET" : "READ_ALL",
                achievementRate: $0 > 10 ? 100 : $0 > 5 ? 44 : 0)
        }
        return GetRankingResponse(ranking: rankings)
    }
}
