//
//  AchievementViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/26/25.
//

struct AchievementViewDatas: BaseEntity {
    let achievements: [AchievementEntity]
    
    init(achievements: [AchievementEntity] = []) {
        self.achievements = achievements
    }
}

struct AchievementEntity: Hashable {
    let day: Int
    let createdCount: Int
    let certificationRate: Int
    
    init(
        day: Int = 0,
        createdCount: Int = 0,
        certificationRate: Int = 0
    ) {
        self.day = day
        self.createdCount = createdCount
        self.certificationRate = certificationRate
    }
}
