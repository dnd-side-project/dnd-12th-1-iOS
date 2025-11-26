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
    
    var updateViewController: (() -> Void)? = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(updateLastAccessDate), name: .NSCalendarDayChanged, object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSCalendarDayChanged, object: nil)
    }
}

// MARK: view
extension NavigationCoordinator {
    func setNavigationController(_ viewController: BaseViewController, datas: (any BaseEntity)? = nil, animated: Bool = true) {
        viewController.coordinator = self
        viewController.datas = datas
        updateViewController = nil
        
        navigationController.setViewControllers([viewController], animated: animated)
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    func pushViewController(_ viewController: BaseViewController, datas: (any BaseEntity)? = nil, animated: Bool = true) {
        viewController.coordinator = self
        viewController.datas = datas
        updateViewController = nil
        
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func presentViewController(_ viewController: BaseViewController, datas: (any BaseEntity)? = nil, animated: Bool = true) {
        viewController.coordinator = self
        viewController.datas = datas
        updateViewController = nil
        
        navigationController.present(viewController, animated: animated)
    }

    func popViewController(animated: Bool = true) {
        updateViewController = nil
        
        navigationController.popViewController(animated: animated)
    }
    
    func popViewControllers(num: Int = 1, animated: Bool = true) {
        let currentIndex = navigationController.viewControllers.count - 1
        if currentIndex - num < 0 { return }    // MARK: index가 마이너스로 넘어가는 잘못된 상황 필터링
        
        let targetViewController = navigationController.viewControllers[currentIndex - num]
        
        updateViewController = nil
        
        navigationController.popToViewController(targetViewController, animated: animated)
    }
    
    func dismissViewController(animated: Bool = true) {
        updateViewController = nil

        navigationController.presentedViewController?.dismiss(animated: animated)
    }
}

// MARK: popup
extension NavigationCoordinator {
    func showPopup(
        _ viewController: BaseViewController,
        type: PopupTypes,
        alertType: AlertTypes? = nil,
        todoInfo: TodoEntity? = nil,
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
                  let _ = currentViewController as? MainViewController else { return }
            
            updateViewController?()
            
        default:
            return
        }
    }
    
    @objc func updateLastAccessDate() {
        if UserDefaultsManager.shared.lastAccessDate != Date().toString() {
            UserDefaultsManager.shared.lastAccessDate = Date().toString()
            
            updateViewController?()
        }
    }
}

extension NavigationCoordinator: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
}
