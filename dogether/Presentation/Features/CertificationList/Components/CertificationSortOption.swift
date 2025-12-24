//
//  CertificationSortOption.swift
//  dogether
//
//  Created by yujaehong on 5/19/25.
//

import Foundation

enum SortOptions: String, CaseIterable, BaseEntity {
    case todoCompletionDate = "투두 완료일순"
    case groupCreationDate = "그룹 생성일순"

    var displayName: String {
        return self.rawValue
    }
    
    var sortString: String {
        switch self {
        case .todoCompletionDate:
            return "TODO_COMPLETED_AT"
        case .groupCreationDate:
            return "GROUP_CREATED_AT"
        }
    }
}
