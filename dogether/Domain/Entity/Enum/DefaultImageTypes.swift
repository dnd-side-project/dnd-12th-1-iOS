//
//  DefaultImageTypes.swift
//  dogether
//
//  Created by seungyooooong on 12/4/25.
//

import UIKit

enum DefaultImageTypes {
    case logo
    case camera
    case embarrassed
    
    var image: UIImage {
        switch self {
        case .logo:
            return .logo
        case .camera:
            return .cameraDosik.setDefaultImagePadding()
        case .embarrassed:
            return .embarrassedDosik.setDefaultImagePadding()
        }
    }
    
    // FIXME: 추후에 CertificationImageView에서 content와 분리 필요, (grey200으로 색 변경)
    var content: String? {
        switch self {
        case .logo:
            return nil
        case .camera:
            return "인증 사진을 업로드 해주세요!"
        case .embarrassed:
            return "아직 열심히 진행중이에요"
        }
    }
}
