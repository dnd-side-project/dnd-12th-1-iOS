//
//  UserRepositoryTest.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

final class UserRepositoryTest: UserProtocol {
    private let userDataSource: UserDataSource

    init(userDataSource: UserDataSource = .shared) {
        self.userDataSource = userDataSource
    }

    func getStatsViewDatas(groupId: Int) async throws -> (
        achievementViewDatas: AchievementViewDatas,
        rankViewDatas: StatsRankViewDatas,
        summaryViewDatas: StatsSummaryViewDatas
    ) {
        guard let activityUrl = Bundle.main.url(forResource: "StatsMock", withExtension: "json"),
              let statsUrl = Bundle.main.url(forResource: "CertificationStatsMock", withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }

        let activityData = try Data(contentsOf: activityUrl)
        let statsData = try Data(contentsOf: statsUrl)

        let activityResponse = try JSONDecoder().decode(GetMyGroupActivityResponse.self, from: activityData)
        let statsResponse = try JSONDecoder().decode(GetMyCertificationStatsResponse.self, from: statsData)

        let achievementViewDatas = AchievementViewDatas(
            achievements: activityResponse.certificationPeriods.map {
                AchievementEntity(
                    day: $0.day,
                    createdCount: $0.createdCount,
                    certificationRate: $0.certificationRate
                )
            }
        )

        let rankViewDatas = StatsRankViewDatas(
            totalMembers: activityResponse.ranking.totalMemberCount,
            myRank: activityResponse.ranking.myRank
        )

        let summaryViewDatas = StatsSummaryViewDatas(
            certificatedCount: statsResponse.certificatedCount,
            approvedCount: statsResponse.approvedCount,
            rejectedCount: statsResponse.rejectedCount
        )

        return (achievementViewDatas, rankViewDatas, summaryViewDatas)
    }

    func getCertificationListViewDatas(option: SortOptions, page: Int) async throws -> (
        statsViewDatas: StatsViewDatas,
        certificationListViewDatas: CertificationListViewDatas
    ) {
        let filename: String
        if option == .todoCompletionDate {
            filename = "TodoCompletedDatePage\(String(page))Mock"
        } else {
            // MARK: option == .groupCreationDate
            filename = "GroupCreatedDatePage\(String(page))Mock"
        }
        guard let activityUrl = Bundle.main.url(forResource: filename, withExtension: "json"),
              let statsUrl = Bundle.main.url(forResource: "CertificationStatsMock", withExtension: "json") else {
            throw NSError(domain: "파일 없음", code: 404)
        }

        let activityData = try Data(contentsOf: activityUrl)
        let statsData = try Data(contentsOf: statsUrl)

        let activityResponse = try JSONDecoder().decode(GetMyActivityResponse.self, from: activityData)
        let statsResponse = try JSONDecoder().decode(GetMyCertificationStatsResponse.self, from: statsData)

        let statsViewDatas = StatsViewDatas(
            achievementCount: statsResponse.certificatedCount,
            approveCount: statsResponse.approvedCount,
            rejectCount: statsResponse.rejectedCount
        )

        let sections: [SectionEntity] = activityResponse.certifications.map { certification in
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
            isLastPage: !activityResponse.pageInfo.hasNext
        )

        return (statsViewDatas, certificationListViewDatas)
    }

    func getProfileViewDatas() async throws -> ProfileViewDatas {
        return ProfileViewDatas(name: "두식", imageUrl: "")
    }
}
