//
//  ExaminateViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 12/4/25.
//

import Foundation

struct ExaminateViewDatas: BaseEntity {
    var index: Int
    var reviews: [ReviewEntity]
    var result: ReviewResults?
    var feedback: String
    
    init(index: Int = 0, reviews: [ReviewEntity] = [], result: ReviewResults? = nil, feedback: String = "") {
        self.index = index
        self.reviews = reviews
        self.result = result
        self.feedback = feedback
    }
}
