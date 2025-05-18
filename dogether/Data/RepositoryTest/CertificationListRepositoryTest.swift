//
//  CertificationListRepositoryTest.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

final class CertificationListRepositoryTest: CertificationListProtocol {
    func fetchByTodoCompletionDate() async throws -> CertificationListResult {
        try await loadAndTransformDaily(from: "TodoCompletedDateMock")
    }
    
    func fetchByGroupCreationDate() async throws -> CertificationListResult {
        try await loadAndTransformGroup(from: "GroupCreatedDateMock")
    }
}

// MARK: - 투두완료일순
extension CertificationListRepositoryTest {
    private func loadAndTransformDaily(from filename: String) async throws -> CertificationListResult {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "파일 없음", code: 404)
        }

        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(CertificationDailyListResponse.self, from: data)
        return transformDailyResponse(decoded)
    }
    
    private func transformDailyResponse(_ response: CertificationDailyListResponse) -> CertificationListResult {
        let items: [CertificationItem] = response.certificationsGroupedByTodoCompletedAt.flatMap { daily in
            daily.certificationInfo.map { info in
                CertificationItem(id: info.id,
                                  content: info.content,
                                  status: info.status,
                                  certificationContent: info.certificationContent,
                                  certificationMediaUrl: info.certificationMediaUrl,
                                  rejectReason: info.rejectReason,
                                  createdAt: daily.createdAt)
            }
        }
        
        let grouped = Dictionary(grouping: items,
                                 by: { $0.createdAt })
        
        let sections: [CertificationSection] = grouped.keys.sorted(by: >).map { date in
            CertificationSection(type: .daily(dateString: date),
                                 certifications: grouped[date] ?? [])
        }
        
        let stats = CertificationStats(totalCertificatedCount: response.dailyTodoStats.totalCertificatedCount,
                                       totalApprovedCount: response.dailyTodoStats.totalApprovedCount,
                                       totalRejectedCount: response.dailyTodoStats.totalRejectedCount)
        
        return CertificationListResult(sections: sections, stats: stats)
    }
}

// MARK: - 그룹생성일순
extension CertificationListRepositoryTest {
    private func loadAndTransformGroup(from filename: String) async throws -> CertificationListResult {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "파일 없음", code: 404)
        }

        let data = try Data(contentsOf: url)
        let decoded = try JSONDecoder().decode(CertificationGroupListResponse.self, from: data)
        return transformGroupResponse(decoded)
    }
    
    private func transformGroupResponse(_ response: CertificationGroupListResponse) -> CertificationListResult {
        let sections: [CertificationSection] = response.certificationsGroupedByGroupCreatedAt.map { group in
            let items: [CertificationItem] = group.certificationInfo.map { info in
                CertificationItem(
                    id: info.id,
                    content: info.content,
                    status: info.status,
                    certificationContent: info.certificationContent,
                    certificationMediaUrl: info.certificationMediaUrl,
                    rejectReason: info.rejectReason,
                    createdAt: "" // group 섹션은 날짜 사용 안 함
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
