//
//  OnboardingSteps.swift
//  dogether
//
//  Created by seungyooooong on 3/25/25.
//

import UIKit

enum OnboardingSteps: Int {
    case one = 1
    case two = 2
    case three = 3
    
    var title: String {
        switch self {
        case .one:
            return "오늘의 목표를 세우고,\n사진으로 투두 인증하기"
        case .two:
            return "투두를 인증하면\n날아오는 팀원의 피드백"
        case .three:
            return "서로 검사해야 다음 목표로 GO"
        }
    }
    
    var subTitle: String {
        switch self {
        case .one:
            return "목표만 세우면 끝?! 인증까지 해야 진짜 실천이에요"
        case .two:
            return "열심히 하면 ‘인정’, 대충하면 ‘노인정’을 받아요"
        case .three:
            return "팀원의 인증을 검사해야\n새로운 목표를 설정할 수 있어요"
        }
    }
    
    var lottieFileName: String {
        switch self {
        case .one: return "onboarding1"
        case .two: return "onboarding2"
        case .three: return "onboarding3"
        }
    }
}
