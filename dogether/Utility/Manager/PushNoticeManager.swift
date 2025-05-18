//
//  PushNoticeManager.swift
//  dogether
//
//  Created by seungyooooong on 2/1/25.
//

import FirebaseMessaging
import UserNotifications

protocol NotificationHandler: AnyObject {
    func handleNotification(userInfo: [AnyHashable: Any])
}

final class PushNoticeManager: NSObject, UNUserNotificationCenterDelegate {
    weak var delegate: NotificationHandler?
    
    static let shared = PushNoticeManager()
    private override init() {
        super.init()
    }
}

// MARK: - handleNotification
extension PushNoticeManager {
    func handleNotification(userInfo: [AnyHashable: Any]) {
        delegate?.handleNotification(userInfo: userInfo)
    }
    
    // MARK: - foreground
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
    
    // MARK: - background
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
