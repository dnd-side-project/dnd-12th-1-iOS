//
//  CertificationListRepository.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

final class CertificationListRepository: CertificationListProtocol {
    private let dataSource: CertificationListDataSource
    
    init(dataSource: CertificationListDataSource = .shared) {
        self.dataSource = dataSource
    }
    
    func fetchByTodoCompletionDate() async throws -> CertificationListResult {
        let response = try await dataSource.fetchByTodoCompletionDate()
        return Self.transformDaily(response: response)
    }
    
    func fetchByGroupCreationDate() async throws -> CertificationListResult {
        let response = try await dataSource.fetchByGroupCreationDate()
        return Self.transformGroup(response: response)
    }
}

// MARK: - 투두완료일순
extension CertificationListRepository {
    private static func transformDaily(response: CertificationDailyListResponse) -> CertificationListResult {
        let items: [CertificationItem] = response.certificationsGroupedByTodoCompletedAt.flatMap { daily in
            daily.certificationInfo.map { info in
                CertificationItem(
                    id: info.id,
                    content: info.content,
                    status: info.status,
                    certificationContent: info.certificationContent,
                    certificationMediaUrl: info.certificationMediaUrl,
                    rejectReason: info.rejectReason,
                    createdAt: daily.createdAt
                )
            }
        }
        
        let grouped = Dictionary(grouping: items, by: { $0.createdAt })
        
        let sections: [CertificationSection] = grouped.keys.sorted(by: >).map { date in
            CertificationSection(
                type: .daily(dateString: date),
                certifications: grouped[date] ?? []
            )
        }
        
        let stats = CertificationStats(
            totalCertificatedCount: response.dailyTodoStats.totalCertificatedCount,
            totalApprovedCount: response.dailyTodoStats.totalApprovedCount,
            totalRejectedCount: response.dailyTodoStats.totalRejectedCount
        )
        
        return CertificationListResult(sections: sections, stats: stats)
    }
}

// MARK: - 그룹생성일순
extension CertificationListRepository {
    private static func transformGroup(response: CertificationGroupListResponse) -> CertificationListResult {
        let sections: [CertificationSection] = response.certificationsGroupedByGroupCreatedAt.map { group in
            let items = group.certificationInfo.map { info in
                CertificationItem(
                    id: info.id,
                    content: info.content,
                    status: info.status,
                    certificationContent: info.certificationContent,
                    certificationMediaUrl: info.certificationMediaUrl,
                    rejectReason: info.rejectReason,
                    createdAt: "" // 그룹은 날짜 미사용
                )
            }
            
            return CertificationSection(
                type: .group(groupName: group.groupName),
                certifications: items
            )
        }
        
        let stats = CertificationStats(
            totalCertificatedCount: response.dailyTodoStats.totalCertificatedCount,
            totalApprovedCount: response.dailyTodoStats.totalApprovedCount,
            totalRejectedCount: response.dailyTodoStats.totalRejectedCount
        )
        
        return CertificationListResult(sections: sections, stats: stats)
    }
}
