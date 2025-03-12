//
//  UIGestureRecognizerExt.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/11/25.
//

import UIKit.UIGeometry

private var GestureActionKey: UInt8 = 0

extension UIGestureRecognizer {
    
    /// 제스처를 대리적으로 처리합니다.
    /// - Parameter action: 제스처의 따른 액션
    ///
    /// 여기서 OBJC 를 사용하였는데
    /// 메모리 관리 정책을 지정하기 위해 설정합니다.
    func addAction(_ action: @escaping () -> Void) {
        let actionWrapper = GestureActionWrapper(action: action)
        /*
         object - 대상 객체
         key - 속성에 대한 키 값. 메모리 값으로 사용. 메모리 관리는 밑에 policy에 따라서 관리합니다.
         value - 객체와 연결하려는 속성 값
         policy - association Policy
         
         OBJC_ASSOCIATION_ASSIGN // 추가된 객체와 약한 참조
         OBJC_ASSOCIATION_RETAIN_NONATOMIC // 추가된 객체와 강력 참조 및 nonatomatic으로 설정 OBJC_ASSOCIATION_COPY_NONATOMIC // 추가된 객체를 복사 및 nonatomatic으로 설정
         OBJC_ASSOCIATION_RETAIN // 추가된 객체와 강력 참조 및 atomatic으로 설정
         OBJC_ASSOCIATION_COPY // 추가된 객체를 복사 및 atomatic으로 설정
         */
        objc_setAssociatedObject(self, &GestureActionKey, actionWrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(actionWrapper, action: #selector(actionWrapper.invoke))
    }
}

/// 제스처 레핑 클래스
fileprivate class GestureActionWrapper {
    /// 액션 반환 클로저
    private let action: () -> Void

    init(
        action: @escaping () -> Void
    ) {
        self.action = action
    }

    /// 액션 대리자
    @objc func invoke() {
        action()
    }
    
    deinit {
        logger.debug("GestureActionWrapper: deinit")
    }
}
