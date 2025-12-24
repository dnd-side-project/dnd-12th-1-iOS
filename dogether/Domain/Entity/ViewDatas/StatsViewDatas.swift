//
//  StatsViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

struct StatsViewDatas: BaseEntity {
    var achievementCount: Int
    var approveCount: Int
    var rejectCount: Int
    
    init(
        achievementCount: Int = 0,
        approveCount: Int = 0,
        rejectCount: Int = 0
    ) {
        self.achievementCount = achievementCount
        self.approveCount = approveCount
        self.rejectCount = rejectCount
    }
}
