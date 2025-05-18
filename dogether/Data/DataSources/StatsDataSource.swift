//
//  StatsDataSource.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

final class StatsDataSource {
    static let shared = StatsDataSource()
    
    private init() {}
    
    func fetchGroupStats(groupId: Int) async throws -> GroupStatsResponse {
        try await NetworkManager.shared.request(StatsRouter.fetchGroupStats(groupId: groupId))
    }
}
