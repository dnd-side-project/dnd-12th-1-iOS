//
//  DogetherGroupInfoViewData.swift
//  dogether
//
//  Created by yujaehong on 11/7/25.
//

import Foundation

struct DogetherGroupInfoViewData: BaseEntity {
    let name: String
    let memberCount: Int
    let duration: GroupChallengeDurations
    let startDay: String
    let endDay: String
}
