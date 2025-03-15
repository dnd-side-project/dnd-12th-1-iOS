//
//  UIViewExt.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/7/25.
//

import UIKit

extension UIViewController {
    
    /// 팝업을 띄웁니다.
    /// - Parameters:
    ///   - type: 팝업 스타일을 정의합니다.
    ///   - animated: 애니메이션을 정의합니다.
    ///   - todoInfo: 투두 정보를 정의합니다.
    ///   - modalPresentationStyle: 팝업띄움에 대한 스타일 정의입니다. ex ) overFullScreen
    ///   - completion: 팝업띄우고 난뒤 호출됩니다.
    ///   - completeAction: -> 해당액션은 나중의 정의
    func showPopup(
        type: PopupTypes,
        animated: Bool = false,
        todoInfo: TodoInfo? = nil,
        modalPresentationStyle: UIModalPresentationStyle = .overFullScreen,
        completion: (() -> Void)? = nil,
        completeAction: ((String) -> Void)? = nil
    ) {
        let popupViewController = PopupViewController()
        
        popupViewController.popupType = type
        popupViewController.todoInfo = todoInfo
        popupViewController.completeAction = completeAction
        popupViewController.modalPresentationStyle = modalPresentationStyle
        self.present(popupViewController, animated: animated, completion: completion)
    }
}


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
