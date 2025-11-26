//
//  GroupStartAts.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit

enum GroupStartAts: String, CaseIterable, BaseEntity {
    case today = "TODAY"
    case tomorrow = "TOMORROW"
    
    var image: UIImage {
        switch self {
        case .today:
            return .today
        case .tomorrow:
            return .tomorrow
        }
    }
    
    var text: String {
        switch self {
        case .today:
            return "오늘"
        case .tomorrow:
            return "내일"
        }
    }
    
    var daysFromToday: Int {
        switch self {
        case .today:
            return 0
        case .tomorrow:
            return 1
        }
    }
    
    var description: String {
        switch self {
        case .today:
            return "오늘부터 실천!\n지금 바로 시작할래요"
        case .tomorrow:
            return "조금 더 준비하고,\n내일부터 시작할래요"
        }
    }
}
