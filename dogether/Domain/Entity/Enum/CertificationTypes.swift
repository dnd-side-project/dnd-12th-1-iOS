//
//  CertificationTypes.swift
//  dogether
//
//  Created by seungyooooong on 11/27/25.
//

import UIKit

enum CertificationTypes {
    case achievement
    case approve
    case reject
    
    var iconImage: UIImage {
        switch self {
        case .achievement:
            return .achievement
        case .approve:
            return .approve
        case .reject:
            return .reject
        }
    }
    
    var text: String {
        switch self {
        case .achievement:
            return "달성"
        case .approve:
            return "인정"
        case .reject:
            return "노인정"
        }
    }
    
    // FIXME: 추후 수정
    var titleLabelWidth: CGFloat {
        switch self {
        case .achievement:
            25
        case .approve:
            25
        case .reject:
            37
        }
    }
}
