//
//  GetMyActivityResponse.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

struct GetMyActivityResponse: Decodable {
    let dailyTodoStats: CertificationStatsInGetMyActivityResponse
    let certificationsGroupedByTodoCompletedAt: [CertificationGroupedByTodoCompletedAt]?
    let certificationsGroupedByGroupCreatedAt: [CertificationGroupedByGroupCreatedAt]?
    let pageInfo: PageInfoInGetMyActivityResponse
}

struct CertificationStatsInGetMyActivityResponse: Decodable {
    let totalCertificatedCount: Int
    let totalApprovedCount: Int
    let totalRejectedCount: Int
}

struct CertificationGroupedByTodoCompletedAt: Decodable {
    let createdAt: String
    let certificationInfo: [CertificationEntityInGetMyActivityResponse]
}

struct CertificationGroupedByGroupCreatedAt: Decodable {
    let groupName: String
    let certificationInfo: [CertificationEntityInGetMyActivityResponse]
}

struct CertificationEntityInGetMyActivityResponse: Decodable {
    let id: Int
    let content: String
    var status: String
    var certificationContent: String
    var certificationMediaUrl: String
    var reviewFeedback: String?
}

struct PageInfoInGetMyActivityResponse: Decodable {
    let totalPageCount: Int
    let recentPageNumber: Int
    let hasNext: Bool
    let pageSize: Int
}
