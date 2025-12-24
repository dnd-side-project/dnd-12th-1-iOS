//
//  RankingEntity.swift
//  dogether
//
//  Created by seungyooooong on 10/13/25.
//

import Foundation

struct RankingEntity: BaseEntity {
    let memberId: Int
    let rank: Int
    let profileImageUrl: String
    let name: String
    let historyReadStatus: HistoryReadStatus?
    let achievementRate: Int
    
    init(
        memberId: Int = 0,
        rank: Int = 0,
        profileImageUrl: String = "",
        name: String = "",
        historyReadStatus: HistoryReadStatus? = nil,
        achievementRate: Int = 0
    ) {
        self.memberId = memberId
        self.rank = rank
        self.profileImageUrl = profileImageUrl
        self.name = name
        self.historyReadStatus = historyReadStatus
        self.achievementRate = achievementRate
    }
}
