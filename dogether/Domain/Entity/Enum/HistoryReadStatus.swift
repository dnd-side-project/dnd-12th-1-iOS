//
//  HistoryReadStatus.swift
//  dogether
//
//  Created by seungyooooong on 10/13/25.
//

import UIKit

enum HistoryReadStatus: String {
    case readYet = "READ_YET"
    case readAll = "READ_ALL"
    
    var colors: [CGColor] {
        switch self {
        case .readYet:
            return [UIColor.blue300.cgColor, UIColor.dogetherYellow.cgColor, UIColor.dogetherRed.cgColor]
        case .readAll:
            return [UIColor.grey500.cgColor, UIColor.grey500.cgColor]
        }
    }
}
