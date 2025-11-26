//
//  GroupCreateViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 11/10/25.
//

import Foundation

struct GroupCreateViewDatas: BaseEntity {
    var step: CreateGroupSteps
    var groupName: String
    var memberCount: Int
    var duration: GroupChallengeDurations
    var startAt: GroupStartAts
    var isFirstResponder: Bool
    
    init(
        step: CreateGroupSteps = .one,
        groupName: String = "",
        member: Int = 10,
        duration: GroupChallengeDurations = .threeDays,
        startAt: GroupStartAts = .today,
        isFirstResponder: Bool = false
    ) {
        self.step = step
        self.groupName = groupName
        self.memberCount = member
        self.duration = duration
        self.startAt = startAt
        self.isFirstResponder = isFirstResponder
    }
}
