//
//  GroupTypes.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import UIKit

enum GroupTypes: Int, CaseIterable {
    case join
    case create
    
    var image: UIImage {
        switch self {
        case .join:
            return .join
        case .create:
            return .create
        }
    }
    
    var startTitleText: String {
        switch self {
        case .join:
            return "초대 코드로 참여하기"
        case .create:
            return "그룹 만들기"
        }
    }
    
    var startSubTitleText: String {
        switch self {
        case .join:
            return "그룹원에게 받은 초대 코드로 참여하세요"
        case .create:
            return "그룹을 만들고 그룹원을 초대해보세요"
        }
    }
    
    var completeTitleText: String {
        switch self {
        case .join:
            return "그룹 가입 완료 !\n이제 목표를 실천해보세요"
        case .create:
            return "그룹 생성 완료 !\n팀원들에게 코드를 공유해보세요"
        }
    }
    
    var destination: BaseViewController {
        switch self {
        case .create:
            return GroupCreateViewController()
        case .join:
            return GroupJoinViewController()
        }
    }
}
