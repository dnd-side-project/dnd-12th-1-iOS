//
//  ReviewEntity.swift
//  dogether
//
//  Created by seungyooooong on 12/4/25.
//

import Foundation

struct ReviewEntity: BaseEntity {
    let id: Int
    let content: String
    let mediaUrl: String
    let todoContent: String
    let doer: String
}
