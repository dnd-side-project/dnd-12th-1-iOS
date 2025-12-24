//
//  CreateGroupSteps.swift
//  dogether
//
//  Created by seungyooooong on 2/12/25.
//

import Foundation

enum CreateGroupSteps: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    
    var description: String {
        switch self {
        case .one:
            return "어떤 그룹을 만들까요?"
        case .two:
            return "어떤 일정으로 진행할까요?"
        case .three:
            return "그룹 정보를 확인해주세요"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .one, .two:
            return "다음"
        case .three:
            return "그룹 생성"
        }
    }
}
