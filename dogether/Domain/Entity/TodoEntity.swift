//
//  TodoEntity.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation

struct TodoEntity: BaseEntity {
    let id: Int
    let content: String
    var status: TodoStatus
    var thumbnailStatus: ThumbnailStatus
    var certificationContent: String?
    var certificationMediaUrl: String?
    var reviewFeedback: String?
    var createdAt: String?
    
    init(
        id: Int,
        content: String,
        status: TodoStatus,
        thumbnailStatus: ThumbnailStatus = .yet,
        certificationContent: String? = nil,
        certificationMediaUrl: String? = nil,
        reviewFeedback: String? = nil,
        createdAt: String? = nil
    ) {
        self.id = id
        self.content = content
        self.status = status
        self.thumbnailStatus = thumbnailStatus
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.reviewFeedback = reviewFeedback
        self.createdAt = createdAt
    }
}
