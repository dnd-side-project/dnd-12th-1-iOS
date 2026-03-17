//
//  GetMyActivityResponse.swift
//  dogether
//
//  Created by seungyooooong on 12/11/25.
//

import Foundation

struct GetMyActivityResponse: Decodable {
    let certifications: [CertificationGroupedResponse]
    let pageInfo: PageInfoInGetMyActivityResponse
}

struct CertificationGroupedResponse: Decodable {
    let groupedBy: String
    let certificationInfo: [CertificationEntityInGetMyActivityResponse]
}

struct CertificationEntityInGetMyActivityResponse: Decodable {
    let id: Int
    let content: String
    var status: String
    var certificationContent: String
    var certificationMediaUrl: String
    var reviewFeedback: String?
}

struct PageInfoInGetMyActivityResponse: Decodable {
    let recentPageNumber: Int
    let hasNext: Bool
}
