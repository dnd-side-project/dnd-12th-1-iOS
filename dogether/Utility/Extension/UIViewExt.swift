//
//  UIViewExt.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/7/25.
//

import UIKit.UIView

extension UIView {
    
    /// 탭 제스처를 추가 합니다.
    /// - Parameter action: 탭에 의한 맥션
    func addTapGesture(action: @escaping () -> Void) {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = false
        tapGesture.addAction(action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    /// 스와이프 제스처를 추가합니다.
    /// - Parameters:
    ///   - direction: 방향을 선택합니다. (기본: 왼쪽)
    ///   - action: 스와이프에 대한 액션
    func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction = .left, action: @escaping () -> Void) {
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.cancelsTouchesInView = false
        swipeGesture.direction = direction
        swipeGesture.addAction(action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(swipeGesture)
    }
    
    
    static var getSafeAreaInsets: UIEdgeInsets? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets
    }
}
