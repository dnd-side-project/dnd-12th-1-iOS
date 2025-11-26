//
//  GroupChallengeDurations.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

enum GroupChallengeDurations: Int, BaseEntity {
    case threeDays = 3
    case oneWeek = 7
    case twoWeeks = 14
    case fourWeeks = 28
    
    var text: String {
        switch self {
        case .threeDays:
            return "3일"
        case .oneWeek:
            return "1주"
        case .twoWeeks:
            return "2주"
        case .fourWeeks:
            return "4주"
        }
    }
}
