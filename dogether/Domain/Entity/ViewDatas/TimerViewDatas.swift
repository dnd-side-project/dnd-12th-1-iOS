//
//  TimerViewDatas.swift
//  dogether
//
//  Created by seungyooooong on 9/20/25.
//

import Foundation

struct TimerViewDatas: BaseEntity {
    var time: String
    var timeProgress: CGFloat
    
    init(time: String = "23:59:59", timeProgress: CGFloat = 0.0) {
        self.time = time
        self.timeProgress = timeProgress
    }
}
