//
//  SheetStatus.swift
//  dogether
//
//  Created by seungyooooong on 2/14/25.
//

import Foundation

enum SheetStatus {
    case expand
    case normal
    
    var offset: CGFloat {
        switch self {
        case .expand:
            return 104
        case .normal:
            return 280
        }
    }
}
