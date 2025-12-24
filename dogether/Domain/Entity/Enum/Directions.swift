//
//  Directions.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

enum Directions {
    case minus
    case plus
    case prev
    case next
    
    var tag: Int {
        switch self {
        case .minus, .prev:
            return -1
        case .plus, .next:
            return 1
        }
    }
}
