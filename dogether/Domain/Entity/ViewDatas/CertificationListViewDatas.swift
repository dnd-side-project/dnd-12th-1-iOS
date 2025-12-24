//
//  CertificationListViewDatas.swift
//  dogether
//
//  Created by yujaehong on 12/8/25.
//

import Foundation

struct CertificationListViewDatas: BaseEntity {
    var sections: [SectionEntity]
    var filter: FilterTypes
    var currentPage: Int
    var isLastPage: Bool
    
    init(
        sections: [SectionEntity] = [],
        filter: FilterTypes = .all,
        currentPage: Int = 0,
        isLastPage: Bool = false,
    ) {
        self.sections = sections
        self.filter = filter
        self.currentPage = currentPage
        self.isLastPage = isLastPage
    }
}

enum SectionType: BaseEntity {
    case daily(dateString: String)
    case group(groupName: String)
}

struct SectionEntity: BaseEntity {
    let type: SectionType
    let todos: [TodoEntity]
}
