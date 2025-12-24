//
//  StatsRankViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/26/25.
//

struct StatsRankViewDatas: BaseEntity {
    let totalMembers: Int
    let myRank: Int
    
    init(
        totalMembers: Int = 0,
        myRank: Int = 0
    ) {
        self.totalMembers = totalMembers
        self.myRank = myRank
    }
}
