//
//  UserUseCase.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class UserUseCase {
    private let repository: UserProtocol
    
    init(repository: UserProtocol) {
        self.repository = repository
    }
    
    func getStatsViewDatas(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        try await repository.getStatsViewDatas(groupId: groupId)
    }
    
    func getCertificationListViewDatas(option: SortOptions, page: Int) async throws -> (
        statsViewDatas: StatsViewDatas,
        certificationListViewDatas: CertificationListViewDatas
    ) {
        try await repository.getCertificationListViewDatas(option: option, page: page)
    }
    
    func getProfileViewDatas() async throws -> ProfileViewDatas {
        try await repository.getProfileViewDatas()
    }
}
