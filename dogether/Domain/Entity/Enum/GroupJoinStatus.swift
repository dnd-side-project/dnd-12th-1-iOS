//
//  GroupJoinStatus.swift
//  dogether
//
//  Created by seungyooooong on 3/26/25.
//

import UIKit

enum GroupJoinStatus {
    case normal
    case error
    
    var text: String {
        switch self {
        case .normal:
            return "초대받은 링크에서 초대코드를 확인할 수 있어요"
        case .error:
            return "해당 번호는 존재하지 않아요 !"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .normal:
            return .grey200
        case .error:
            return .dogetherRed
        }
    }
    
    var font: UIFont {
        switch self {
        case .normal:
            return Fonts.body1R
        case .error:
            return Fonts.body1S
        }
    }
    
    var borderColor: UIColor {
        switch self {
        case .normal:
            return .clear
        case .error:
            return .dogetherRed
        }
    }
}
