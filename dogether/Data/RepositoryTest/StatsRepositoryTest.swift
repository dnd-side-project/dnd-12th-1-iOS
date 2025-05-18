//
//  StatsRepositoryTest.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

final class StatsRepositoryTest: StatsProtocol {
    func fetchGroupStats(groupId: Int) async throws -> GroupStatsResponse {
        guard let url = Bundle.main.url(forResource: "StatsMock", withExtension: "json") else {
                   throw URLError(.fileDoesNotExist)
               }
               let data = try Data(contentsOf: url)
               return try JSONDecoder().decode(GroupStatsResponse.self, from: data)
    }
}
