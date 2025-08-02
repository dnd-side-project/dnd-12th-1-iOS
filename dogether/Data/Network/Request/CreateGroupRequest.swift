//
//  CreateGroupRequest.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import Foundation

struct CreateGroupRequest: Encodable {
    let groupName: String
    let maximumMemberCount: Int
    let startAt: String
    let duration: Int
    
    init(groupName: String, maximumMemberCount: Int, startAt: String, duration: Int) {
        self.groupName = groupName
        self.maximumMemberCount = maximumMemberCount
        self.startAt = startAt
        self.duration = duration
    }
}
