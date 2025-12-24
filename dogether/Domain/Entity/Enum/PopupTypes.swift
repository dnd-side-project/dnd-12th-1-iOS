//
//  PopupTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/15/25.
//

import UIKit

enum PopupTypes {
    case alert
    case examinate
}

enum AlertTypes {
    case pushNotice
    
    case gallery
    case camera
    
    case leaveGroup
    case logout
    case withdraw
    
    case saveTodo
    
    // MARK: detail errors
    case needLogout
    case needRevoke
    case alreadyParticipated
    case fullGroup
    case unableToParticipate
    
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
        case .needLogout:
            return "로그인 정보가 만료됐어요"
        case .needRevoke:
            return "로그인 연결을 해제해주세요"
        case .alreadyParticipated:
            return "이미 참여한 그룹이에요"
        case .fullGroup:
            return "그룹 인원이 가득 찼어요"
        case .unableToParticipate:
            return "참여할 수 없는 그룹이에요"
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
        case .needLogout:
            return "다시 로그인해 주세요."
        case .needRevoke:
            return "로그인이 정상적으로 진행되지 않아 Apple 계정에서 dogether 연결을 해제해야 해요. 아래 경로로 이동해 삭제한 뒤 다시 시도해주세요.\n\n '설정 > 내 AppleID > Apple로 로그인 > dogether > 삭제'"
        case .alreadyParticipated:
            return "해당 그룹은 다시 참여하실 수 없어요."
        case .fullGroup:
            return "다른 그룹에 참여하거나 새로 만들어주세요."
        case .unableToParticipate:
            return "종료되었거나 유효하지 않은 그룹이에요."
        default:
            return nil
        }
    }
    
    var cancelText: String? {
        switch self {
        case .pushNotice, .gallery, .camera:
            return "나중에"
        case .leaveGroup, .withdraw, .saveTodo:
            return "뒤로가기"
        case .alreadyParticipated, .fullGroup, .unableToParticipate:
            return "다시 입력하기"
        default:
            return nil
        }
    }
    
    var buttonText: String? {
        switch self {
        case .pushNotice, .gallery, .camera:
            return "설정 열기"
        case .leaveGroup, .withdraw:
            return "탈퇴하기"
        case .logout:
            return "로그아웃"
        case .saveTodo:
            return "저장하기"
        case .needLogout, .needRevoke, .alreadyParticipated, .fullGroup, .unableToParticipate:
            return "확인"
//        default:
//            return nil
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .leaveGroup, .withdraw:
            return .dogetherRed
        case .pushNotice, .gallery, .camera, .logout, .saveTodo,
                .needLogout, .needRevoke, .alreadyParticipated, .fullGroup, .unableToParticipate:
            return .blue300
        }
    }
    
    var image: UIImage? {
        switch self {
        case .pushNotice, .gallery, .camera, .saveTodo,
                .needLogout, .needRevoke, .alreadyParticipated, .fullGroup, .unableToParticipate:
            return .caution
        default:
            return nil
        }
    }
}
