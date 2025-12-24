//
//  UserProtocol.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

protocol UserProtocol {
    func getStatsViewDatas(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    )
    
    func getCertificationListViewDatas(option: SortOptions, page: Int) async throws -> (
        statsViewDatas: StatsViewDatas,
        certificationListViewDatas: CertificationListViewDatas
    )
    
    func getProfileViewDatas() async throws -> ProfileViewDatas
}
