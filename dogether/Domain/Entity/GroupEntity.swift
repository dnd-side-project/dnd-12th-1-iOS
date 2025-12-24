//
//  GroupEntity.swift
//  dogether
//
//  Created by seungyooooong on 9/2/25.
//

import Foundation

struct GroupEntity: BaseEntity {
    let id: Int
    let name: String
    let currentMember: Int
    let maximumMember: Int
    let joinCode: String
    let status: MainViewStatus
    let startDate: String
    let endDate: String
    let duration: Int
    let progress: Float
    
    init(
        id: Int = 0,
        name: String = "",
        currentMember: Int = 0,
        maximumMember: Int = 0,
        joinCode: String = "00000000",
        status: MainViewStatus = .running,
        startDate: String = "00.00.00",
        endDate: String = "00.00.00",
        duration: Int = 0,
        progress: Float = 0
    ) {
        self.id = id
        self.name = name
        self.currentMember = currentMember
        self.maximumMember = maximumMember
        self.joinCode = joinCode
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.duration = duration
        self.progress = progress
    }
}
