//
//  ButtonStatus.swift
//  dogether
//
//  Created by seungyooooong on 2/13/25.
//

import UIKit

enum ButtonStatus {
    case enabled
    case disabled
    
    var textColor: UIColor {
        switch self {
        case .enabled:
            return .grey800
        case .disabled:
            return .grey400
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .enabled:
            return .blue300
        case .disabled:
            return .grey500
        }
    }
}
