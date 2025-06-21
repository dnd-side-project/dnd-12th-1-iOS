//
//  MemberCertificationInfo.swift
//  dogether
//
//  Created by seungyooooong on 4/22/25.
//

import Foundation

struct MemberCertificationInfo {
    let id: Int
    let content: String
    let status: TodoStatus
    let certificationContent: String?
    let certificationMediaUrl: String?
    let feedback: String?
    var thumbnailStatus: ThumbnailStatus
    
    init(
        id: Int = 0,
        content: String = "",
        status: TodoStatus = .waitExamination,
        certificationContent: String? = nil,
        certificationMediaUrl: String? = nil,
        feedback: String? = nil,
        thumbnailStatus: ThumbnailStatus = .yet
    ) {
        self.id = id
        self.content = content
        self.status = status
        self.certificationContent = certificationContent
        self.certificationMediaUrl = certificationMediaUrl
        self.feedback = feedback
        self.thumbnailStatus = thumbnailStatus
    }
}
