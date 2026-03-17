//
//  UserRepository.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class UserRepository: UserProtocol {
    private let userDataSource: UserDataSource
    
    init(userDataSource: UserDataSource = .shared) {
        self.userDataSource = userDataSource
    }
    
    func getStatsViewDatas(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        async let activityResponse = userDataSource.getMyGroupActivity(groupId: groupId)
        async let statsResponse = userDataSource.getMyCertificationStats(groupId: groupId)

        let (activity, stats) = try await (activityResponse, statsResponse)

        let achievementViewDatas = AchievementViewDatas(
            achievements: activity.certificationPeriods.map {
                AchievementEntity(
                    day: $0.day,
                    createdCount: $0.createdCount,
                    certificationRate: $0.certificationRate
                )
            }
        )

        let rankViewDatas = StatsRankViewDatas(
            totalMembers: activity.ranking.totalMemberCount,
            myRank: activity.ranking.myRank
        )

        let summaryViewDatas = StatsSummaryViewDatas(
            certificatedCount: stats.certificatedCount,
            approvedCount: stats.approvedCount,
            rejectedCount: stats.rejectedCount
        )

        return (achievementViewDatas, rankViewDatas, summaryViewDatas)
    }
    
    func getCertificationListViewDatas(option: SortOptions, page: Int) async throws -> (
        statsViewDatas: StatsViewDatas,
        certificationListViewDatas: CertificationListViewDatas
    ) {
        async let activityResponse = userDataSource.getMyActivity(sort: option.sortString, page: String(page))
        async let statsResponse = userDataSource.getMyCertificationStats()

        let (activity, stats) = try await (activityResponse, statsResponse)

        let statsViewDatas = StatsViewDatas(
            achievementCount: stats.certificatedCount,
            approveCount: stats.approvedCount,
            rejectCount: stats.rejectedCount
        )

        let sections: [SectionEntity] = activity.certifications.map { certification in
            let todos = certification.certificationInfo.map { info in
                TodoEntity(
                    id: info.id,
                    content: info.content,
                    status: TodoStatus(rawValue: info.status) ?? .waitCertification,
                    certificationContent: info.certificationContent,
                    certificationMediaUrl: info.certificationMediaUrl,
                    reviewFeedback: info.reviewFeedback,
                    createdAt: option == .todoCompletionDate ? certification.groupedBy : nil
                )
            }

            switch option {
            case .todoCompletionDate:
                return SectionEntity(type: .daily(dateString: certification.groupedBy), todos: todos)
            case .groupCreationDate:
                return SectionEntity(type: .group(groupName: certification.groupedBy), todos: todos)
            }
        }

        let certificationListViewDatas = CertificationListViewDatas(
            sections: sections,
            isLastPage: !activity.pageInfo.hasNext
        )

        return (statsViewDatas, certificationListViewDatas)
    }
    
    func getProfileViewDatas() async throws -> ProfileViewDatas {
        let response = try await userDataSource.getMyProfile()
        return ProfileViewDatas(
            name: response.name,
            imageUrl: response.profileImageUrl
        )
    }
}
