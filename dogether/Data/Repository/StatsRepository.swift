//
//  StatsRepository.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

final class StatsRepository: StatsProtocol {
    private let dataSoruce: StatsDataSource
    
    init(dataSoruce: StatsDataSource = .shared) {
        self.dataSoruce = dataSoruce
    }
    
    func fetchGroupStats(groupId: Int) async throws -> GroupStatsResponse {
        try await dataSoruce.fetchGroupStats(groupId: groupId)
    }
}
