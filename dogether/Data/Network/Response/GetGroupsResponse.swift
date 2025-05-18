//
//  GetGroupsResponse.swift
//  dogether
//
//  Created by seungyooooong on 4/27/25.
//

import Foundation

struct GetGroupsResponse: Decodable {
    let joiningChallengeGroups: [JoiningChallengeGroups]
}

struct JoiningChallengeGroups: Decodable {
    let groupId: Int
    let groupName: String
    let currentMemberCount: Int
    let maximumMemberCount: Int
    let joinCode: String
    let status: String
    let startAt: String
    let endAt: String
    let progressDay: Int
    let progressRate: Float
}
