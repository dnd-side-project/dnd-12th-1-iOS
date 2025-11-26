//
//  CompleteViewDatas.swift
//  dogether
//
//  Created by yujaehong on 10/26/25.
//

import Foundation

struct CompleteViewDatas: BaseEntity {
    var groupType: GroupTypes
    var joinCode: String
    var groupInfo: ChallengeGroupInfo
    
    init(
        groupType: GroupTypes = .create,
        joinCode: String = "",
        groupInfo: ChallengeGroupInfo = ChallengeGroupInfo()
    ) {
        self.groupType = groupType
        self.joinCode = joinCode
        self.groupInfo = groupInfo
    }
}
