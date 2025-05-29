//
//  NavigationCoordinator.swift
//  dogether
//
//  Created by seungyooooong on 3/21/25.
//

import UIKit

// MARK: AnyObject를 채택해 '클래스 전용' 프로토콜로 만들어 줌
protocol CoordinatorDelegate: AnyObject {
    var coordinator: NavigationCoordinator? { get set }
}

final class NavigationCoordinator: NSObject {
    private let navigationController: UINavigationController
    private var modalityWindow: UIWindow? = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: view
extension NavigationCoordinator {
    // ???: 데이터를 더 안전하게 (coordinator를 통해) 전달하는 방식을 찾아보자

    func setNavigationController(_ viewController: BaseViewController, animated: Bool = true) {
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: animated)
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    func pushViewController(_ viewController: BaseViewController, animated: Bool = true) {
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func popViewController(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }
}

// MARK: popup
extension NavigationCoordinator {
    func showPopup(
        _ viewController: BaseViewController,
        type: PopupTypes,
        alertType: AlertTypes? = nil,
        todoInfo: TodoInfo? = nil,
        animated: Bool = true,
        completion: ((Any) -> Void)? = nil
    ) {
        let popupViewController = PopupViewController()
        
        popupViewController.coordinator = self
        popupViewController.completion = completion
        popupViewController.modalPresentationStyle = .overFullScreen
        popupViewController.modalTransitionStyle = .crossDissolve
        
        popupViewController.viewModel.popupType = type
        popupViewController.viewModel.alertType = alertType
        popupViewController.viewModel.todoInfo = todoInfo
        
        viewController.present(popupViewController, animated: animated)
    }
    
    func hidePopup(animated: Bool = true) {
        if let modalityWindow {
            modalityWindow.rootViewController?.dismiss(animated: animated)
        } else {
            navigationController.viewControllers.last?.dismiss(animated: animated)
        }
    }
}

// MARK: modality
extension NavigationCoordinator {
    func showModal(reviews: [ReviewModel]? = nil) {
        if let modalityWindow {
            if let viewController = modalityWindow.rootViewController as? ModalityViewController {
                viewController.viewModel.setReviews(reviews)
                viewController.updateView()
            }
        } else {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = UIWindow(windowScene: windowScene!)
            let modalityViewController = ModalityViewController()
            
            modalityViewController.coordinator = self
            modalityViewController.viewModel.setReviews(reviews)
            window.frame = UIScreen.main.bounds
            window.rootViewController = modalityViewController
            window.windowLevel = .alert + 1
            window.makeKeyAndVisible()
            
            modalityWindow = window
        }
    }
    
    func hideModal() {
        modalityWindow?.isHidden = true
        modalityWindow = nil
    }
}

// MARK: about push notice
extension NavigationCoordinator: NotificationHandler {
    func handleNotification(userInfo: [AnyHashable: Any]) {
        guard let notificationTypeString = userInfo["type"] as? String,
              let notificationType = PushNoticeTypes(rawValue: notificationTypeString) else { return }
        
        switch notificationType {
        case .certification:
            Task { [weak self] in
                guard let self else { return }
                let repository = DIManager.shared.getTodoCertificationsRepository()
                let response = try await repository.getReviews()
                let reviews = response.dailyTodoCertifications
                
                if reviews.isEmpty { return }
                await MainActor.run { self.showModal(reviews: reviews) }
            }
            
        case .review:
            guard let currentViewController = navigationController.viewControllers.last,
                  let mainViewController = currentViewController as? MainViewController else { return }
            // FIXME: 추후 메인화면 개편과 함께 수정, 자정 새로고침에 대해 고려
            Task { [weak mainViewController] in
                guard let self = mainViewController else { return }
                try await self.viewModel.updateListInfo()
                await MainActor.run { self.updateList() }
            }
            
        default:
            return
        }
    }
}

extension NavigationCoordinator: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
}
