//
//  PopupTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit

enum PopupTypes {
    case alert
    case reviewFeedback
}

enum AlertTypes {
    case pushNotice
    
    case gallery
    case camera
    
    case leaveGroup
    case logout
    case withdraw
    
    case saveTodo
    
    var title: String {
        switch self {
        case .pushNotice:
            return "알림 권한이 꺼져 있어요."
        case .gallery:
            return "사진 접근이 제한되어 있어요."
        case .camera:
            return "카메라 권한이 꺼져 있어요."
        case .leaveGroup:
            return "선택한 그룹을 탈퇴하시겠어요?"
        case .logout:
            return "로그아웃 하시겠어요?"
        case .withdraw:
            return "정말 회원탈퇴를 하시겠어요?"
        case .saveTodo:
            return "투두를 저장하시겠습니까?"
        }
    }
    
    var message: String? {
        switch self {
        case .pushNotice:
            return "팀원들의 인증을 놓칠 수도 있어요!\n검사를 위해 설정에서 알림 권한을 켜주세요."
        case .gallery:
            return "인증을 위해 설정에서 권한을 허용해주세요."
        case .camera:
            return" 인증을 위해 설정에서 카메라 권한을 켜주세요."
        case .leaveGroup:
            return "그룹을 탈퇴하면 그룹 내 모든 데이터가\n삭제되어 복구할 수 없어요."
        case .withdraw:
            return "탈퇴하면 모든 데이터가 삭제되며\n복구할 수 없어요."
        case .saveTodo:
            return "한 번 저장한 투두는 수정과 삭제가 불가능합니다"
        default:
            return nil
        }
    }
    
    var cancelText: String {
        switch self {
        case .pushNotice, .gallery, .camera:
            return "나중에"
        default:
            return "뒤로가기"
        }
    }
    
    var buttonText: String {
        switch self {
        case .pushNotice, .gallery, .camera:
            return "설정 열기"
        case .leaveGroup, .withdraw:
            return "탈퇴하기"
        case .logout:
            return "로그아웃"
        case .saveTodo:
            return "저장하기"
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .leaveGroup, .withdraw:
            return .dogetherRed
        case .pushNotice, .gallery, .camera, .logout, .saveTodo:
            return .blue300
        }
    }
    
    var image: UIImage? {
        switch self {
        case .pushNotice, .gallery, .camera, .saveTodo:
            return .caution
        default:
            return nil
        }
    }
}
