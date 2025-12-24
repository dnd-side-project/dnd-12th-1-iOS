//
//  GetMyGroupActivityResponse.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

struct GetMyGroupActivityResponse: Decodable {
//    let group: GroupEntityInGetMyGroupActivity  // MARK: 사용 안함
    let certificationPeriods: [CertificationPeriodEntityInGetMyGroupActivity]
    let ranking: RankingEntityInGetMyGroupActivity
    let stats: StatsEntityInGetMyGroupActivity
}

// MARK: 사용 안함
struct GroupEntityInGetMyGroupActivity: Decodable {
    let name: String
    let maximumMemberCount: Int
    let currentMemberCount: Int
    let joinCode: String
    let endAt: String
}

struct CertificationPeriodEntityInGetMyGroupActivity: Decodable {
    let day: Int
    let createdCount: Int
    let certificatedCount: Int
    let certificationRate: Int
}

struct RankingEntityInGetMyGroupActivity: Decodable {
    let totalMemberCount: Int
    let myRank: Int
}

struct StatsEntityInGetMyGroupActivity: Decodable {
    let certificatedCount: Int
    let approvedCount: Int
    let rejectedCount: Int
}
