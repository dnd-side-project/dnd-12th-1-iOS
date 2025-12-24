//
//  GetReviewsResponse.swift
//  dogether
//
//  Created by seungyooooong on 2/5/25.
//

import Foundation

struct GetReviewsResponse: Decodable {
    let dailyTodoCertifications: [dailyTodoCertification]
}

struct dailyTodoCertification: Decodable {
    let id: Int
    let content: String
    let mediaUrl: String
    let todoContent: String
    let doer: String
}
