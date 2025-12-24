//
//  GroupViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 9/2/25.
//

import Foundation

struct GroupViewDatas: BaseEntity {
    var index: Int
    var groups: [GroupEntity]
    
    init(index: Int = 0, groups: [GroupEntity] = []) {
        self.index = index
        self.groups = groups
    }
}
