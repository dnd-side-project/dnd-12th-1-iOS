//
//  PopupManager.swift
//  dogether
//
//  Created by seungyooooong on 2/16/25.
//

import Foundation
import UIKit

@available(*, deprecated, message: "해당 메니저는 더이상 사용되지 않습니다.")
final class PopupManager {
//    static let shared = PopupManager()

    private init() {}

//    func showPopup(
//        type: PopupTypes,
//        animated: Bool = true,
//        completion: (() -> Void)? = nil,
//        todoInfo: TodoInfo? = nil,
//        completeAction: ((String) -> Void)? = nil
//    ) {
//        guard let currentViewController = getCurrentViewController() else { return }
//
//        let popupViewController = PopupViewController()
//        popupViewController.popupType = type
//        popupViewController.todoInfo = todoInfo
//        popupViewController.completeAction = completeAction
//        popupViewController.modalPresentationStyle = .fullScreen
//        popupViewController.modalTransitionStyle = .crossDissolve
//        currentViewController.present(popupViewController, animated: animated, completion: completion)
//    }
    
//    func hidePopup(animated: Bool = true) {
//        guard let currentViewController = getCurrentViewController() else { return }
//        currentViewController.dismiss(animated: animated)
//    }

//    private func getCurrentViewController() -> UIViewController? {
//        guard let window = getCurrentWindow(),
//              let rootViewController = window.rootViewController else { return nil }
//        
//        var currentViewController = rootViewController
//        while let presentedViewController = currentViewController.presentedViewController {
//            currentViewController = presentedViewController
//        }
//        
//        return currentViewController
//    }
    
//    private func getCurrentWindow() -> UIWindow? {
//        if let window = ModalityManager.shared.window {
//            return window
//        } else {
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                  let window = windowScene.windows.first else { return nil }
//            return window
//        }
//    }
}
