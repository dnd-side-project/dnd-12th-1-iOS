//
//  CertificationMethods.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit

enum CertificationMethods: Int {
    case gallery
    case camera
    
    var title: String {
        switch self {
        case .gallery:
            return "사진 선택"
        case .camera:
            return "사진 촬영"
        }
    }
    
    var image: UIImage {
        switch self {
        case .gallery:
            return .gallery
        case .camera:
            return .camera
        }
    }
}
