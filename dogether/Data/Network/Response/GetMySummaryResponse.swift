//
//  GetMySummaryResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/4/25.
//

import Foundation

struct GetMySummaryResponse: Decodable {
    let totalTodoCount: Int
    let totalCertificatedCount: Int
    let totalApprovedCount: Int
    let totalRejectedCount: Int
}
