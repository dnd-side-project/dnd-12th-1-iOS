//
//  CertificationViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 10/18/25.
//

import Foundation

struct CertificationViewDatas: BaseEntity {
    var title: String
    var todos: [TodoEntity]
    var index: Int
    var groupId: Int?
    var rankingEntity: RankingEntity?
    
    init(
        title: String = "",
        todos: [TodoEntity] = [],
        index: Int = 0,
        groupId: Int? = nil,
        rankingEntity: RankingEntity? = nil
    ) {
        self.title = title
        self.todos = todos
        self.index = index
        self.groupId = groupId
        self.rankingEntity = rankingEntity
    }
}
