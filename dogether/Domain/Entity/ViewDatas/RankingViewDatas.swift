//
//  RankingViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/11/25.
//

import Foundation

struct RankingViewDatas: BaseEntity {
    var groupId: Int
    var rankings: [RankingEntity]
    
    init(groupId: Int = 0, rankings: [RankingEntity] = []) {
        self.groupId = groupId
        self.rankings = rankings
    }
}
