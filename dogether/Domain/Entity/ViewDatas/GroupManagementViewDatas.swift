//
//  GroupManagementViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/29/25.
//

import Foundation

struct GroupManagementViewDatas: BaseEntity {
    var groups: [GroupEntity]
    
    init(groups: [GroupEntity] = []) {
        self.groups = groups
    }
}
