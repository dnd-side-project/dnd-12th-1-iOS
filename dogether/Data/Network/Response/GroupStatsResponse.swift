//
//  GroupStatsResponse.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

struct GroupStatsResponse: Decodable {
    let groupInfo: GroupInformation
    let certificationPeriods: [CertificationPeriod]
    let ranking: Ranking
    let stats: Stats
}

struct GroupInformation: Decodable {
    let name: String
    let maximumMemberCount: Int
    let currentMemberCount: Int
    let joinCode: String
    let endAt: String
}

struct CertificationPeriod: Decodable {
    let day: Int
    let createdCount: Int
    let certificatedCount: Int
    let certificationRate: Int
}

struct Ranking: Decodable {
    let totalMemberCount: Int
    let myRank: Int
}

struct Stats: Decodable {
    let certificatedCount: Int
    let approvedCount: Int
    let rejectedCount: Int
}
