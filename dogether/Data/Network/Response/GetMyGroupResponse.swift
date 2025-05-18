//
//  GetMyGroupResponse.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

struct GetMyGroupResponse: Decodable {
    let joiningChallengeGroups: [ChallengeGroup]
}

struct ChallengeGroup: Decodable {
    let groupId: Int
    let groupName: String
    let currentMemberCount: Int
    let maximumMemberCount: Int
    let joinCode: String
    let status: GroupStatus
    let startAt: String
    let endAt: String
    let progressDay: Int
    let progressRate: Double
}

enum GroupStatus: String, Decodable {
    case ready = "READY"
    case running = "RUNNING"
    case dDay = "D_DAY"
    case finished = "FINISHED"
}
