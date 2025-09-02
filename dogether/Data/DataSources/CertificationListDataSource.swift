//
//  CertificationListDataSource.swift
//  dogether
//
//  Created by yujaehong on 5/6/25.
//

import Foundation

final class CertificationListDataSource {
    static let shared = CertificationListDataSource()
    
    private init() {}
    
    func fetchByTodoCompletionDate(sort: String, page: String) async throws -> CertificationDailyListResponse {
        try await NetworkManager.shared.request(
            CertificationListRouter.getMyActivity(sort: sort, page: page)
        )
    }
    
    func fetchByGroupCreationDate(sort: String, page: String) async throws -> CertificationGroupListResponse {
        try await NetworkManager.shared.request(
            CertificationListRouter.getMyActivity(sort: sort, page: page)
        )
    }
}
