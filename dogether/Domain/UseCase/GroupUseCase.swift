//
//  GroupUseCase.swift
//  dogether
//
//  Created by seungyooooong on 3/2/25.
//

import Foundation

final class GroupUseCase {
    private let repository: GroupProtocol
    
    init(repository: GroupProtocol) {
        self.repository = repository
    }
    
    func createGroup(groupCreateViewDatas: GroupCreateViewDatas) async throws -> String {
        try await repository.createGroup(groupCreateViewDatas: groupCreateViewDatas)
    }
    
    func joinGroup(joinCode: String) async throws -> GroupEntity {
        let joinGroupRequest = JoinGroupRequest(joinCode: joinCode)
        let response = try await repository.joinGroup(joinGroupRequest: joinGroupRequest)
        return GroupEntity(
            name: response.groupName,
            maximumMember: response.maximumMemberCount,
            startDate: response.startAt,
            endDate: response.endAt,
            duration: response.duration
        )
    }
    
    func leaveGroup(groupId: Int) async throws {
        try await repository.leaveGroup(groupId: String(groupId))
    }
    
    func checkParticipating() async throws -> Bool {
        let response = try await repository.checkParticipating()
        return response.checkParticipating
    }
    
    func getGroups() async throws -> GroupViewDatas {
        return try await repository.getGroups()
    }
    
    // FIXME: 추후 삭제
    func getGroups() async throws -> (groupIndex: Int?, groups: [GroupEntity]) {
        let response = try await repository.getGroupsBefore()
        return (response.lastSelectedGroupIndex , response.joiningChallengeGroups.map {
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
        })
    }
    
    func saveLastSelectedGroup(groupId: Int?) async throws {
        guard let groupId  else { return }
        let saveLastSelectedGroupRequest = SaveLastSelectedGroupRequest(groupId: String(groupId))
        try await repository.saveLastSelectedGroup(saveLastSelectedGroupRequest: saveLastSelectedGroupRequest)
    }
    
    func getRankings(groupId: Int) async throws -> [RankingEntity] {
        let response = try await repository.getRanking(groupId: String(groupId))
        return response.ranking.map {
            RankingEntity(
                memberId: $0.memberId,
                rank: $0.rank,
                profileImageUrl: $0.profileImageUrl,
                name: $0.name,
                historyReadStatus: HistoryReadStatus(rawValue: $0.historyReadStatus),
                achievementRate: $0.achievementRate)
        }
    }
}

// MARK: - group create
extension GroupUseCase {
    func validateMemberCount(count: Int, min: Int, max: Int) -> Bool {
        return min <= count && count <= max
    }
}
