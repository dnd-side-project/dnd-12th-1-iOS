//
//  CertificationListResponse.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

// MARK: - 공통 도메인 모델

/// 기본 인증 정보 모델 (공통으로 사용)
struct CertificationInfo: Codable {
    let id: Int
    let content: String
    let status: String
    let certificationContent: String
    let certificationMediaUrl: String
    let reviewFeedback: String?
}

/// 인증 통계 정보
struct CertificationStats: Codable {
    let totalCertificatedCount: Int
    let totalApprovedCount: Int
    let totalRejectedCount: Int
}

struct PageInfo: Codable {
    let totalPageCount: Int
    let recentPageNumber: Int
    let hasNext: Bool
    let pageSize: Int
}

// MARK: - API 응답 모델

// 🔴 [투두 완료일순 리스트 응답]

/// 일일 인증 데이터
struct CertificationDailyListResponse: Codable {
    let dailyTodoStats: CertificationStats
    let certificationsGroupedByTodoCompletedAt: [DailyTodoCertification]
    let pageInfo: PageInfo
}

/// 인증 정보 + 생성일자
struct DailyTodoCertification: Codable {
    let createdAt: String
    let certificationInfo: [CertificationInfo]
}

// 🔵 [그룹 생성일순 리스트 응답]

/// 그룹 인증 데이터
struct CertificationGroupListResponse: Codable {
    let dailyTodoStats: CertificationStats
    let certificationsGroupedByGroupCreatedAt: [GroupTodoCertification]
    let pageInfo: PageInfo 
}

/// 그룹명 + 인증 정보 + 생성일자
struct GroupTodoCertification: Codable {
    let groupName: String
    let certificationInfo: [CertificationInfo]
}

// MARK: - View 전용 Presentation Model

/// 인증 섹션의 유형 (날짜 or 그룹 기준)
enum CertificationSectionType {
    case daily(dateString: String)
    case group(groupName: String)
}

/// 하나의 인증 리스트 아이템
struct CertificationItem {
    let id: Int
    let content: String
    let status: String
    let certificationContent: String
    let certificationMediaUrl: String
    let reviewFeedback: String?
    let createdAt: String
}

/// 섹션별 인증 묶음
struct CertificationSection {
    let type: CertificationSectionType
    let certifications: [CertificationItem]
}

/// ViewModel → View 에 전달할 데이터 묶음
struct CertificationListResult {
    let sections: [CertificationSection]
    let stats: CertificationStats
    let hasNext: Bool
}
