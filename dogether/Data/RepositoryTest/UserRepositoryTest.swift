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
        guard let url = Bundle.main.url(forResource: "StatsMock", withExtension: "json") else {
           throw URLError(.fileDoesNotExist)
       }
       let data = try Data(contentsOf: url)
       let response = try JSONDecoder().decode(GetMyGroupActivityResponse.self, from: data)
        
        let achievementViewDatas = AchievementViewDatas(
            achievements: response.certificationPeriods.map {
                AchievementEntity(
                    day: $0.day,
                    createdCount: $0.createdCount,
                    certificationRate: $0.certificationRate
                )
            }
        )
        
        let rankViewDatas = StatsRankViewDatas(
            totalMembers: response.ranking.totalMemberCount,
            myRank: response.ranking.myRank
        )
        
        let summaryViewDatas = StatsSummaryViewDatas(
            certificatedCount: response.stats.certificatedCount,
            approvedCount: response.stats.approvedCount,
            rejectedCount: response.stats.rejectedCount
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
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "파일 없음", code: 404)
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(GetMyActivityResponse.self, from: data)
        
        let statsViewDatas = StatsViewDatas(
            achievementCount: response.dailyTodoStats.totalCertificatedCount,
            approveCount: response.dailyTodoStats.totalApprovedCount,
            rejectCount: response.dailyTodoStats.totalRejectedCount
        )
        
        let sections: [SectionEntity]
        if let certificationsGroupedByTodoCompletedAt = response.certificationsGroupedByTodoCompletedAt {
            sections = certificationsGroupedByTodoCompletedAt.map { daily in
                let todos = daily.certificationInfo.map { info in
                    TodoEntity(
                        id: info.id,
                        content: info.content,
                        status: TodoStatus(rawValue: info.status) ?? .waitCertification,
                        certificationContent: info.certificationContent,
                        certificationMediaUrl: info.certificationMediaUrl,
                        reviewFeedback: info.reviewFeedback,
                        createdAt: daily.createdAt
                    )
                }
                return SectionEntity(type: .daily(dateString: daily.createdAt), todos: todos)
            }
        } else if let certificationsGroupedByGroupCreatedAt = response.certificationsGroupedByGroupCreatedAt {
            sections = certificationsGroupedByGroupCreatedAt.map { group in
                let todos = group.certificationInfo.map { info in
                    TodoEntity(
                        id: info.id,
                        content: info.content,
                        status: TodoStatus(rawValue: info.status) ?? .waitCertification,
                        certificationContent: info.certificationContent,
                        certificationMediaUrl: info.certificationMediaUrl,
                        reviewFeedback: info.reviewFeedback
                    )
                }
                
                return SectionEntity(type: .group(groupName: group.groupName), todos: todos)
            }
        } else { sections = [] }
        
        let certificationListViewDatas = CertificationListViewDatas(
            sections: sections,
            isLastPage: !response.pageInfo.hasNext
        )
        
        return (statsViewDatas, certificationListViewDatas)
    }
    
    func getProfileViewDatas() async throws -> ProfileViewDatas {
        return ProfileViewDatas(name: "두식", imageUrl: "")
    }
}
