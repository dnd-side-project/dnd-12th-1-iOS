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
    var groupEntity: GroupEntity
    
    init(
        groupType: GroupTypes = .create,
        joinCode: String = "",
        groupEntity: GroupEntity = GroupEntity()
    ) {
        self.groupType = groupType
        self.joinCode = joinCode
        self.groupEntity = groupEntity
    }
}
