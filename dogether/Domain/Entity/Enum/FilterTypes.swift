//
//  FilterTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import UIKit

enum FilterTypes: String, CaseIterable {
    case all = "전체"
    case wait = "검사 대기"
    case reject = "노인정"
    case approve = "인정"
    
    var tag: Int {
        switch self {
        case .all:
            return 0
        case .wait:
            return 1
        case .reject:
            return 2
        case .approve:
            return 3
        }
    }
    
    var image: UIImage? {
        switch self {
        case .all:
            return nil
        case .wait:
            return .wait
        case .reject:
            return .reject
        case .approve:
            return .approve
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .all, .approve:
            return .blue300
        case .wait:
            return .dogetherYellow
        case .reject:
            return .dogetherRed
        }
    }
    
    var width: CGFloat {
        switch self {
        case .all:
            return 48
        case .wait:
            return 89
        case .reject:
            return 74
        case .approve:
            return 62
        }
    }
    
    var emptyDescription: String {
        switch self {
        case .wait:
            return "검사 대기 중인 투두가 없어요"
        case .reject:
            return "노인정받은 투두가 없어요"
        case .approve:
            return "인정받은 투두가 없어요"
        default:
            return ""
        }
    }
    
    var reviewResult: ReviewResults? {
        switch self {
        case .reject:
            return .reject
        case .approve:
            return .approve
        default:
            return nil
        }
    }
}

extension FilterTypes {
    init?(status: String) {
        switch status.uppercased() {
        case "REVIEW_PENDING":
            self = .wait
        case "REJECT":
            self = .reject
        case "APPROVE":
            self = .approve
        default:
            return nil
        }
    }
}
