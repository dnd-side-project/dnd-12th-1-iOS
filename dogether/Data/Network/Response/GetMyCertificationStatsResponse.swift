//
//  GetMyCertificationStatsResponse.swift
//  dogether
//
//  Created by yujaehong on 1/31/26.
//

import Foundation

struct GetMyCertificationStatsResponse: Decodable {
    let certificatedCount: Int
    let approvedCount: Int
    let rejectedCount: Int
}
