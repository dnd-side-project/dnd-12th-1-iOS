//
//  GetRankingResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct GetRankingResponse: Decodable {
    let ranking: [RankingResponse]
}

struct RankingResponse: Decodable {
    let memberId: Int
    let rank: Int
    let profileImageUrl: String
    let name: String
    let historyReadStatus: String
    let achievementRate: Int
}
