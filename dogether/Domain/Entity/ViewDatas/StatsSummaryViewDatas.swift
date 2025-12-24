//
//  StatsSummaryViewDatas.swift
//  dogether
//
//  Created by yujaehong on 11/26/25.
//

struct StatsSummaryViewDatas: BaseEntity {
    let certificatedCount: Int
    let approvedCount: Int
    let rejectedCount: Int
    
    init(
        certificatedCount: Int = 0,
        approvedCount: Int = 0,
        rejectedCount: Int = 0
    ) {
        self.certificatedCount = certificatedCount
        self.approvedCount = approvedCount
        self.rejectedCount = rejectedCount
    }
}
