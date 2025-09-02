//
//  CertificationListUseCase.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

final class CertificationListUseCase {
    private let repository: CertificationListProtocol
    
    init(repository: CertificationListProtocol) {
        self.repository = repository
    }
    
    func fetchSortedList(option: CertificationSortOption, page: Int) async throws -> CertificationListResult {
        let pageString = String(page)
        let sortString = option.sortType.rawValue
        switch option {
        case .todoCompletionDate:
            return try await repository.fetchByTodoCompletionDate(sort: sortString, page: pageString)
        case .groupCreationDate:
            return try await repository.fetchByGroupCreationDate(sort: sortString, page: pageString)
        }
    }
}
