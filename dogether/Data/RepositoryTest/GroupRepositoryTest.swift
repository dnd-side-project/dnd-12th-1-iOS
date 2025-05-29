//
//  GroupRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import Foundation

final class GroupRepositoryTest: GroupProtocol {
    func createGroup(createGroupRequest: CreateGroupRequest) async throws -> CreateGroupResponse {
        return CreateGroupResponse(joinCode: "000000")
    }
    
    func joinGroup(joinGroupRequest: JoinGroupRequest) async throws -> JoinGroupResponse {
        // MARK: - TEST: 99999999 입력 시 에러 발생 테스트
        if joinGroupRequest.joinCode == "99999999" { throw NetworkError.unknown }
        return JoinGroupResponse(groupName: "testGroup", duration: 3, maximumMemberCount: 10, startAt: "2025-01-01", endAt: "2025-01-04")
    }
    
    func getIsParticipating() async throws -> GetIsParticipatingResponse {
        return GetIsParticipatingResponse(isParticipating: true)
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
    
    func getMyGroup() async throws -> GetMyGroupResponse {
        guard let url = Bundle.main.url(forResource: "GroupMock", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(GetMyGroupResponse.self, from: data)
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
                achievementRate: $0)
        }
        return GetRankingResponse(ranking: rankings)
    }
}
