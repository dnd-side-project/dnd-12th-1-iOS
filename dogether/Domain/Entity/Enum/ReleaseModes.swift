//
//  ReleaseModes.swift
//  dogether
//
//  Created by seungyooooong on 5/28/25.
//

import Foundation

enum ReleaseModes {
    case prod
    case dev
    
    var urlString: String {
        switch self {
        case .prod:
            return "https://api-prod.dogether.site"
        case .dev:
            return "https://api-dev.dogether.site"
        }
    }
}
