//
//  UIViewControllerExt.swift
//  dogether
//
//  Created by Jae hyung Kim on 3/15/25.
//

import UIKit.UIViewController

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
    
    
    /// 베이스 팝업 뷰컨트롤러 대리 함수 입니다.
    /// - Parameters:
    ///   - type: 팝업 뷰 타입
    ///   - horizontalPadding: 좌우 패딩값
    ///   - configuration: 뷰 설정
    func showPopUp<V: BasePopUpView>(
        type: V.Type,
        horizontalPadding: CGFloat = 20,
        backgroundDismissOption: Bool = true,
        configuration: ((V) -> Void)? = nil
    ) {
        let popupVC = BasePopUpViewController<V>(horizontalPadding: horizontalPadding)
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        
        configuration?(popupVC.popUpView)
        
        self.present(popupVC, animated: false)
    }
    
    /// 베이스 팝업 뷰컨트롤러 대리 함수 입니다.
    /// - Parameters:
    ///   - type: 팝업 뷰 인스턴스
    ///   - horizontalPadding: 좌우 패딩값
    ///   - configuration: 뷰 설정
    func showPopUp<V: BasePopUpView>(
        view: V,
        horizontalPadding: CGFloat = 20,
        backgroundDismissOption: Bool = true,
        configuration: ((V) -> Void)? = nil
    ) {
        let popupVC = BasePopUpViewController(view: view, horizontalPadding: horizontalPadding)
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        
        configuration?(popupVC.popUpView)
        
        self.present(popupVC, animated: false)
    }
}
