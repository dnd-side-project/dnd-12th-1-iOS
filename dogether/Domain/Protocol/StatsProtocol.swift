//
//  StatsProtocol.swift
//  dogether
//
//  Created by yujaehong on 5/7/25.
//

import Foundation

protocol StatsProtocol {
    func fetchGroupStats(groupId: Int) async throws -> GroupStatsResponse
}
