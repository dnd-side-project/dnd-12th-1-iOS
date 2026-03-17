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
    
    private var lastViewController: UIViewController? {
        if let modalityWindow { return modalityWindow.rootViewController }
        else { return navigationController.viewControllers.last }
    }
    
    // MARK: 날짜 이동, pushNotice에 반응하여 viewController 자체를 update하는 임시 함수
    var updateViewController: (() -> Void)? = nil
    
    func checkCurrentViewController(_ types: UIViewController.Type...) -> Bool {
        guard let currentViewController = navigationController.viewControllers.last else { return false }
        
        return types.contains { currentViewController.isKind(of: $0) }
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLastAccessDate),
            name: .NSCalendarDayChanged, object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .NSCalendarDayChanged, object: nil)
    }
}

// MARK: view
extension NavigationCoordinator {
    func setNavigationController(
        _ viewControllers: BaseViewController...,
        datas: (any BaseEntity)? = nil,
        animated: Bool = true
    ) {
        // MARK: 하나 이상의 viewController 확인
        if viewControllers.isEmpty { return }
        
        // MARK: 마지막 viewController에만 datas 연동
        viewControllers.forEach { $0.coordinator = self }
        viewControllers.last?.datas = datas
        updateViewController = nil
        
        navigationController.setViewControllers(viewControllers, animated: animated)
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    func pushViewController(_ viewController: BaseViewController, datas: (any BaseEntity)? = nil, animated: Bool = true) {
        // MARK: 새로 넣으려는 viewController와 현재 viewController가 같을 때는 page update
        if let currentViewController = navigationController.viewControllers.last as? BaseViewController,
           let datas, type(of: viewController) == type(of: currentViewController) {
            currentViewController.pages?.forEach { $0.updateView(datas) }
            return
        }
        
        viewController.coordinator = self
        viewController.datas = datas
        updateViewController = nil
        
        navigationController.pushViewController(viewController, animated: animated)
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
}

// MARK: popup
extension NavigationCoordinator {
    func showPopup(
        type: PopupTypes,
        alertType: AlertTypes? = nil,
        animated: Bool = true,
        completion: ((Any) -> Void)? = nil
    ) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            let popupViewController = PopupViewController()
            
            switch type {
            case .alert:
                let alertPopupViewDatas = AlertPopupViewDatas(type: alertType)
                popupViewController.datas = alertPopupViewDatas
                
            case .examinate:
                let examinatePopupViewDatas = ExaminatePopupViewDatas()
                popupViewController.datas = examinatePopupViewDatas
            }
            
            popupViewController.coordinator = self
            popupViewController.completion = completion
            popupViewController.modalPresentationStyle = .overFullScreen
            popupViewController.modalTransitionStyle = .crossDissolve
            
            lastViewController?.present(popupViewController, animated: animated)
        }
    }
    
    func hidePopup(animated: Bool = true) {
        lastViewController?.dismiss(animated: animated)
    }
}

// MARK: modality
extension NavigationCoordinator {
    func showModal(reviews: [ReviewEntity]) {
        if let modalityWindow {
            if let viewController = modalityWindow.rootViewController as? ModalityViewController {
                viewController.updateReviewsAction(reviews: reviews)
            }
        } else {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = UIWindow(windowScene: windowScene!)
            let modalityViewController = ModalityViewController()
            
            modalityViewController.coordinator = self
            modalityViewController.datas = ExaminateViewDatas(reviews: reviews)
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

// MARK: error
extension NavigationCoordinator {
    func showErrorView(completion: @escaping () -> Void) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            if let errorViewController = navigationController.presentedViewController as? ErrorViewController {
                errorViewController.completions.append(completion)
            } else {
                let errorViewController = ErrorViewController()
                
                errorViewController.coordinator = self
                errorViewController.completions.append(completion)
                errorViewController.modalPresentationStyle = .overFullScreen
                errorViewController.modalTransitionStyle = .crossDissolve
                
                navigationController.present(errorViewController, animated: true)
            }
        }
    }
    
    func dismissErrorView(completion: @escaping () -> Void) {
        updateViewController = nil

        navigationController.presentedViewController?.dismiss(animated: true) { completion() }
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
                let reviews = try await repository.getReviews()
                
                if reviews.isEmpty { return }
                await MainActor.run { self.showModal(reviews: reviews) }
            }
            
        case .review:
            if checkCurrentViewController(
                MainViewController.self,
                RankingViewController.self,
                StatsViewController.self
            ) {
                updateViewController?()
            }
            
        case .join:
            if checkCurrentViewController(
                MainViewController.self,
                RankingViewController.self,
                StatsViewController.self,
                GroupManagementViewController.self
            ) {
                updateViewController?()
            }
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
